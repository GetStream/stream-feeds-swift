//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Combine
import Foundation
import StreamCore

/// An observable state object that manages the current state of a member list.
///
/// `MemberListState` maintains the current list of members, pagination information,
/// and provides real-time updates when members are added, removed, or modified.
/// It automatically handles WebSocket events to keep the member list synchronized.
@MainActor public class MemberListState: ObservableObject {
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
        eventSubscription = publisher.subscribe { [weak self] event in
            switch event {
            case .feedMemberDeleted(let memberId, let feedId):
                guard feedId == self?.query.feed else { return }
                await self?.access { state in
                    guard let index = state.members.firstIndex(where: { $0.id == memberId }) else { return }
                    state.members.remove(at: index)
                }
            case .feedMemberUpdated(let member, let feedId):
                guard feedId == self?.query.feed else { return }
                await self?.access { state in
                    state.members.replace(byId: member)
                }
            case .feedMemberBatchUpdate(let updates, let feedId):
                guard feedId == self?.query.feed else { return }
                await self?.access { state in
                    // Skip added because the it might not belong to this list
                    state.members.replace(byIds: updates.updated)
                    state.members.remove(byIds: updates.removedIds)
                }
            default:
                break
            }
        }
    }

    func access<T>(_ actions: @MainActor (MemberListState) -> T) -> T {
        actions(self)
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
