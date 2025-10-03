//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Combine
import Foundation
import StreamCore

public final class FeedList: Sendable {
    private let feedsRepository: FeedsRepository
    private let disposableBag = DisposableBag()
    private let refetchSubject = AllocatedUnfairLock(PassthroughSubject<Void, Never>())
    private let refetchDelay: Int
    @MainActor private let stateBuilder: StateBuilder<FeedListState>

    init(query: FeedsQuery, client: FeedsClient, refetchDelay: Int = 5) {
        feedsRepository = client.feedsRepository
        self.query = query
        self.refetchDelay = refetchDelay
        let eventPublisher = client.stateLayerEventPublisher
        stateBuilder = StateBuilder { [refetchSubject] in
            FeedListState(query: query, eventPublisher: eventPublisher, refetchSubject: refetchSubject)
        }
        subscribeToRefetch()
    }

    public let query: FeedsQuery

    // MARK: - Accessing the State

    /// An observable object representing the current state of the feed list.
    @MainActor public var state: FeedListState { stateBuilder.state }

    // MARK: - Paginating the List of Feeds

    @discardableResult public func get() async throws -> [FeedData] {
        try await queryFeeds(with: query)
    }

    @discardableResult public func queryMoreFeeds(limit: Int? = nil) async throws -> [FeedData] {
        let nextQuery: FeedsQuery? = await state.access { state in
            guard let next = state.pagination?.next else { return nil }
            return FeedsQuery(
                filter: state.queryConfig?.filter,
                sort: state.queryConfig?.sort,
                limit: limit,
                next: next,
                previous: nil,
                watch: query.watch
            )
        }
        guard let nextQuery else { return [] }
        return try await queryFeeds(with: nextQuery)
    }

    // MARK: - Private

    private func queryFeeds(with query: FeedsQuery) async throws -> [FeedData] {
        let result = try await feedsRepository.queryFeeds(with: query)
        await state.didPaginate(
            with: result,
            for: .init(filter: query.filter, sort: query.sort)
        )
        return result.models
    }
    
    /// Refetches all the feeds and updates the state once when pagination has ended.
    private func subscribeToRefetch() {
        refetchSubject.withLock { [disposableBag, refetchDelay] subject in
            subject
                .debounce(for: .seconds(refetchDelay), scheduler: DispatchQueue.global(qos: .utility))
                .asyncSink { [weak self] _ in
                    guard let self else { return }
                    do {
                        let batches = await self.state.access { state in
                            let limit = state.feeds.count
                            let pageSize = 25
                            return stride(from: 0, to: limit, by: pageSize).map { min(pageSize, limit - $0) }
                        }
                        guard !batches.isEmpty else { return }
                        var next: String?
                        var refetchedFeeds = [FeedData]()
                        for batch in batches {
                            let result = try await self.feedsRepository.queryFeeds(
                                with: FeedsQuery(
                                    filter: query.filter,
                                    sort: query.sort,
                                    limit: batch,
                                    next: next,
                                    previous: nil,
                                    watch: query.watch
                                )
                            )
                            next = result.pagination.next
                            refetchedFeeds.append(contentsOf: result.models)
                        }
                        await self.state.didRefetch(refetchedFeeds)
                    } catch {
                        log.error("Failed to refetch", subsystems: .other, error: error)
                    }
                }
                .store(in: disposableBag)
        }
    }
}
