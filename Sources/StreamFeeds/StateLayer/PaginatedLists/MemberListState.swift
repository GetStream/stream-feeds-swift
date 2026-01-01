//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Combine
import Foundation
import StreamCore

/// An observable state object that manages the current state of a member list.
///
/// `MemberListState` maintains the current list of members, pagination information,
/// and provides real-time updates when members are added, removed, or modified.
/// It automatically handles WebSocket events to keep the member list synchronized.
@MainActor public final class MemberListState: ObservableObject, StateAccessing {
    private var eventSubscription: StateLayerEventPublisher.Subscription?

    init(query: MembersQuery, eventPublisher: StateLayerEventPublisher) {
        self.query = query
        subscribe(to: eventPublisher)
    }

    /// The original query configuration used to fetch members.
    ///
    /// This contains the feed ID, filters, and sorting options that were used
    /// to create the initial member list.
    public let query: MembersQuery

    /// All the paginated members currently loaded.
    ///
    /// This array contains all members that have been fetched across multiple
    /// pagination requests. The members are automatically sorted according to
    /// the current sorting configuration.
    @Published public private(set) var members: [FeedMemberData] = []

    // MARK: - Pagination State

    /// Last pagination information from the most recent request.
    ///
    /// Contains the `next` and `previous` cursor values that can be used
    /// to fetch additional pages of members.
    public private(set) var pagination: PaginationData?

    /// Indicates whether there are more members available to load.
    ///
    /// Returns `true` if there are additional members that can be fetched
    /// using the pagination information, `false` otherwise.
    public var canLoadMore: Bool { pagination?.next != nil }

    /// The configuration used for the last query.
    ///
    /// Contains the filter and sort parameters that were applied to the
    /// most recent member fetch operation.
    private(set) var queryConfig: QueryConfiguration<MembersFilter, MembersSortField>?

    var membersSorting: [Sort<MembersSortField>] {
        if let sort = queryConfig?.sort, !sort.isEmpty {
            return sort
        }
        return Sort<MembersSortField>.defaultSorting
    }
}

// MARK: - Updating the State

extension MemberListState {
    private func subscribe(to publisher: StateLayerEventPublisher) {
        let matchesQuery: @Sendable (FeedMemberData) -> Bool = { [query] member in
            guard let filter = query.filter else { return true }
            return filter.matches(member.toLocalFilterModel(feed: query.feed))
        }
        eventSubscription = publisher.subscribe { [weak self, query] event in
            switch event {
            case .feedMemberAdded(let memberData, let eventFeedId):
                guard eventFeedId == query.feed else { return }
                guard matchesQuery(memberData) else { return }
                await self?.access { state in
                    state.members.sortedInsert(memberData, sorting: state.membersSorting)
                }
            case .feedMemberDeleted(let memberId, let eventFeedId):
                guard eventFeedId == query.feed else { return }
                await self?.access { state in
                    state.members.remove(byId: memberId)
                }
            case .feedMemberUpdated(let memberData, let eventFeedId):
                guard eventFeedId == query.feed else { return }
                let matches = matchesQuery(memberData)
                await self?.access { state in
                    if matches {
                        state.members.sortedReplace(memberData, nesting: nil, sorting: state.membersSorting)
                    } else {
                        state.members.remove(byId: memberData.id)
                    }
                }
            case .feedMemberBatchUpdate(let updates, let eventFeedId):
                guard eventFeedId == query.feed else { return }
                let added = updates.added.filter(matchesQuery)
                let updatedNotMatching = updates.updated.filter { !matchesQuery($0) }.map(\.id)
                await self?.access { state in
                    added.forEach { state.members.sortedInsert($0, sorting: state.membersSorting) }
                    updates.updated.forEach { state.members.sortedReplace($0, nesting: nil, sorting: state.membersSorting) }
                    state.members.remove(byIds: updatedNotMatching)
                    state.members.remove(byIds: updates.removedIds)
                }
            default:
                break
            }
        }
    }

    func applyUpdates(_ updates: ModelUpdates<FeedMemberData>) {
        // Skip added because the it might not belong to this list
        members.replace(byIds: updates.updated)
        members.remove(byIds: updates.removedIds)
    }

    func didPaginate(
        with response: PaginationResult<FeedMemberData>,
        for queryConfig: QueryConfiguration<MembersFilter, MembersSortField>
    ) {
        pagination = response.pagination
        self.queryConfig = queryConfig
        members = members.sortedMerge(response.models, sorting: membersSorting)
    }
}
