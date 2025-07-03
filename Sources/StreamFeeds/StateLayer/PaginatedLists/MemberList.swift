//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class MemberList: Sendable {
    @MainActor private let stateBuilder: StateBuilder<MemberListState>
    private let feedsRepository: FeedsRepository
    
    init(query: MembersQuery, client: FeedsClient) {
        self.feedsRepository = client.feedsRepository
        self.query = query
        let events = client.eventsMiddleware
        stateBuilder = StateBuilder { MemberListState(query: query, events: events) }
    }

    public let query: MembersQuery
    
    // MARK: - Accessing the State
    
    /// An observable object representing the current state of the member list.
    @MainActor public var state: MemberListState { stateBuilder.state }
    
    // MARK: - Paginating the List of Members
    
    @discardableResult
    public func get() async throws -> [FeedMemberData] {
        try await queryMembers(with: query)
    }
    
    @discardableResult
    public func queryMoreMembers(limit: Int? = nil) async throws -> [FeedMemberData] {
        let nextQuery: MembersQuery? = await state.access { state in
            guard let next = state.pagination?.next else { return nil }
            return MembersQuery(
                fid: query.fid,
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
    
    private func queryMembers(with query: MembersQuery) async throws -> [FeedMemberData] {
        let response = try await feedsRepository.queryFeedMembers(
            feedGroupId: query.fid.group,
            feedId: query.fid.id,
            request: query.toRequest()
        )
        let members = response.members.map { $0.toModel() }
        let pagination = PaginationData(next: response.next, previous: response.prev)
        let result = PaginationResult(models: members, pagination: pagination)
        await state.didPaginate(
            with: result,
            for: .init(filter: query.filter, sort: query.sort)
        )
        return result.models
    }
} 