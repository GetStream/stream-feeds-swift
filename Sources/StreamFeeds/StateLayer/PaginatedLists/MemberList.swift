//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// A class that manages a paginated list of feed members.
///
/// `MemberList` provides functionality to query and paginate through members of a specific feed.
/// It maintains the current state of the member list and provides methods to load more members
/// when available.
public final class MemberList: Sendable {
    private let disposableBag = DisposableBag()
    @MainActor private let stateBuilder: StateBuilder<MemberListState>
    private let feedsRepository: FeedsRepository

    init(query: MembersQuery, client: FeedsClient) {
        feedsRepository = client.feedsRepository
        self.query = query
        let eventPublisher = client.stateLayerEventPublisher
        stateBuilder = StateBuilder { MemberListState(query: query, eventPublisher: eventPublisher) }
        subscribeToReconnectionRefresh(of: client, in: disposableBag)
    }

    /// The query configuration used to fetch members.
    ///
    /// This contains the feed ID, filters, sorting options, and pagination parameters
    /// that define which members are retrieved and how they are ordered.
    public let query: MembersQuery

    // MARK: - Accessing the State

    /// An observable object representing the current state of the member list.
    ///
    /// This property provides access to the current members, pagination state,
    /// and other state information. The state is automatically updated when
    /// new members are loaded or when real-time updates are received.
    @MainActor public var state: MemberListState { stateBuilder.state }

    // MARK: - Paginating the List of Members

    /// Fetches the initial list of members based on the current query configuration.
    ///
    /// This method loads the first page of members according to the query's filters,
    /// sorting, and limit parameters. The results are stored in the state and can
    /// be accessed through the `state.members` property.
    ///
    /// - Returns: An array of `FeedMemberData` representing the fetched members.
    /// - Throws: An error if the network request fails or the response cannot be parsed.
    @discardableResult
    public func get() async throws -> [FeedMemberData] {
        try await queryMembers(with: query)
    }

    /// Loads the next page of members if more are available.
    ///
    /// This method fetches additional members using the pagination information
    /// from the previous request. If no more members are available, an empty
    /// array is returned.
    ///
    /// - Parameter limit: Optional limit for the number of members to fetch.
    ///   If not specified, uses the limit from the original query.
    /// - Returns: An array of `FeedMemberData` representing the additional members.
    ///   Returns an empty array if no more members are available.
    /// - Throws: An error if the network request fails or the response cannot be parsed.
    @discardableResult
    public func queryMoreMembers(limit: Int? = nil) async throws -> [FeedMemberData] {
        let nextQuery: MembersQuery? = await state.access { state in
            guard let next = state.pagination?.next else { return nil }
            return MembersQuery(
                feed: query.feed,
                filter: state.queryConfig?.filter,
                sort: state.queryConfig?.sort,
                limit: limit,
                next: next,
                previous: nil
            )
        }
        guard let nextQuery else { return [] }
        return try await queryMembers(with: nextQuery)
    }

    // MARK: - Private

    private func fetchMembers(with query: MembersQuery) async throws -> PaginationResult<FeedMemberData> {
        let response = try await feedsRepository.queryFeedMembers(
            feedGroupId: query.feed.group,
            feedId: query.feed.id,
            request: query.toRequest()
        )
        let members = response.members.map { $0.toModel() }
        let pagination = PaginationData(next: response.next, previous: response.prev)
        return PaginationResult(models: members, pagination: pagination)
    }

    private func queryMembers(with query: MembersQuery) async throws -> [FeedMemberData] {
        let result = try await fetchMembers(with: query)
        await state.didPaginate(
            with: result,
            for: .init(filter: query.filter, sort: query.sort)
        )
        return result.models
    }
}

// MARK: - Refetching

extension MemberList: StateRefetching {
    func loadedCount() async -> Int? {
        await state.access { $0.pagination == nil ? nil : $0.members.count }
    }

    func fetchPage(next: String?) async throws -> PaginationResult<FeedMemberData> {
        var pageQuery = query
        if let next {
            pageQuery.next = next
            pageQuery.previous = nil
        }
        return try await fetchMembers(with: pageQuery)
    }

    func didRefetch(_ result: PaginationResult<FeedMemberData>) async {
        await state.didRefetch(with: result)
    }
}
