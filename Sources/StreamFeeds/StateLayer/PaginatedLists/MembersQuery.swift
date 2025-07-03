//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public struct MembersQuery: Sendable {
    public var fid: FeedId
    public var filter: MembersFilter?
    public var limit: Int?
    public var next: String?
    public var previous: String?
    public var sort: [Sort<MembersSortField>]?

    public init(
        fid: FeedId,
        filter: MembersFilter? = nil,
        sort: [Sort<MembersSortField>]? = nil,
        limit: Int? = nil,
        next: String? = nil,
        previous: String? = nil
    ) {
        self.fid = fid
        self.filter = filter
        self.limit = limit
        self.next = next
        self.previous = previous
        self.sort = sort
    }
}

// MARK: - Filters

public struct MembersFilterField: FilterFieldRepresentable, Sendable {
    public let value: String
    
    public init(value: String) {
        self.value = value
    }
    
    init(codingKey: FeedMemberResponse.CodingKeys) {
        self.value = codingKey.rawValue
    }
}

extension MembersFilterField {
    public static let createdAt = Self(codingKey: .createdAt)
    public static let role = Self(codingKey: .role)
    public static let status = Self(codingKey: .status)
    public static let updatedAt = Self(codingKey: .updatedAt)
    public static let userId = Self(value: "user_id")
}

public struct MembersFilter: Filter {
    public init(filterOperator: FilterOperator, field: MembersFilterField, value: any FilterValue) {
        self.filterOperator = filterOperator
        self.field = field
        self.value = value
    }
    
    public let field: MembersFilterField
    public let value: any FilterValue
    public let filterOperator: FilterOperator
}

// MARK: - Sorting

public struct MembersSortField: SortField {
    public typealias Model = FeedMemberData
    public let comparator: AnySortComparator<Model>
    public let remote: String
    
    public init<Value>(_ remote: String, localValue: @escaping @Sendable (Model) -> Value) where Value : Comparable {
        self.comparator = SortComparator(localValue).toAny()
        self.remote = remote
    }
    
    public static let createdAt = Self("created_at", localValue: \.createdAt)
    public static let updatedAt = Self("updated_at", localValue: \.updatedAt)
    public static let userId = Self("user_id", localValue: \.user.id)
}

extension Sort where Field == MembersSortField {
    static let defaultSorting = [Sort(field: .createdAt, direction: .reverse)]
}

// MARK: -

extension MembersQuery {
    func toRequest() -> QueryFeedMembersRequest {
        QueryFeedMembersRequest(
            filter: filter.flatMap { $0.toRawJSON() },
            limit: limit,
            next: next,
            prev: previous,
            sort: sort?.map { $0.toRequest() }
        )
    }
} 
