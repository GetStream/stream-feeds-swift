//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class CommentList: Sendable {
    private let disposableBag = DisposableBag()
    @MainActor private let stateBuilder: StateBuilder<CommentListState>
    private let commentsRepository: CommentsRepository
    
    init(query: CommentsQuery, client: FeedsClient) {
        commentsRepository = client.commentsRepository
        self.query = query
        let eventPublisher = client.stateLayerEventPublisher
        let currentUserId = client.user.id
        stateBuilder = StateBuilder { [eventPublisher] in
            CommentListState(
                query: query,
                currentUserId: currentUserId,
                eventPublisher: eventPublisher
            )
        }
        subscribeToReconnectionRefresh(of: client, in: disposableBag)
    }

    public let query: CommentsQuery
    
    // MARK: - Accessing the State
    
    /// An observable object representing the current state of the comment list.
    @MainActor public var state: CommentListState { stateBuilder.state }
    
    // MARK: - Paginating the List of Comments
    
    @discardableResult public func get() async throws -> [CommentData] {
        try await queryComments(with: query)
    }
    
    @discardableResult public func queryMoreComments(limit: Int? = nil) async throws -> [CommentData] {
        let nextQuery: CommentsQuery? = await state.access { state in
            guard let next = state.pagination?.next else { return nil }
            return CommentsQuery(
                filter: state.queryConfig?.filter,
                sort: state.queryConfig?.sort,
                limit: limit,
                next: next,
                previous: nil
            )
        }
        guard let nextQuery else { return [] }
        return try await queryComments(with: nextQuery)
    }
    
    // MARK: - Private
    
    private func queryComments(with query: CommentsQuery) async throws -> [CommentData] {
        let result = try await commentsRepository.queryComments(request: query.toRequest())
        await state.didPaginate(
            with: result,
            filter: query.filter,
            sort: query.sort
        )
        return result.models
    }
}

// MARK: - Refetching

extension CommentList: StateRefetching {
    var refetchLimit: Int? { query.limit }
    
    func loadedCount() async -> Int? {
        await state.access { $0.pagination == nil ? nil : $0.comments.count }
    }
    
    func fetchPage(limit: Int, next: String?) async throws -> PaginationResult<CommentData> {
        var pageQuery = query
        pageQuery.limit = limit
        pageQuery.next = next
        pageQuery.previous = nil
        return try await commentsRepository.queryComments(request: pageQuery.toRequest())
    }
    
    func didRefetch(_ result: PaginationResult<CommentData>) async {
        await state.didRefetch(with: result)
    }
}
