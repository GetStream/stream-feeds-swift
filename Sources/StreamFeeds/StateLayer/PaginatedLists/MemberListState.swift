//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Combine
import Foundation
import StreamCore

@MainActor public class MemberListState: ObservableObject {
    private var webSocketObserver: WebSocketObserver?
    lazy var changeHandlers: ChangeHandlers = makeChangeHandlers()
    
    init(query: MembersQuery, events: WSEventsSubscribing) {
        self.query = query
        webSocketObserver = WebSocketObserver(fid: query.fid, subscribing: events, handlers: changeHandlers)
    }
    
    public let query: MembersQuery
    
    /// All the paginated members.
    @Published public private(set) var members: [FeedMemberData] = []
    
    // MARK: - Pagination State
    
    /// Last pagination information.
    public private(set) var pagination: PaginationData?
    
    /// Indicates whether there are more members available to load.
    public var canLoadMore: Bool { pagination?.next != nil }
    
    /// The configuration used for the last query.
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
    struct ChangeHandlers {
        let memberRemoved: @MainActor (String) -> Void
        let memberUpdated: @MainActor (FeedMemberData) -> Void
    }
    
    private func makeChangeHandlers() -> ChangeHandlers {
        ChangeHandlers(
            memberRemoved: { [weak self] memberId in
                guard let index = self?.members.firstIndex(where: { $0.id == memberId }) else { return }
                self?.members.remove(at: index)
            },
            memberUpdated: { [weak self] member in
                self?.members.replace(byId: member)
            },
        )
    }
    
    func access<T>(_ actions: @MainActor (MemberListState) -> T) -> T {
        actions(self)
    }
    
    func didPaginate(
        with response: PaginationResult<FeedMemberData>,
        for queryConfig: QueryConfiguration<MembersFilter, MembersSortField>
    ) {
        pagination = response.pagination
        self.queryConfig = queryConfig
        members = members.sortedMerge(response.models, using: membersSorting)
    }
} 
