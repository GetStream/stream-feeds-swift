//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation

public struct FeedsQuery: Sendable {
    public let filter: FeedsFilter?
    public let limit: Int?
    public let next: String?
    public let previous: String?
    public let sort: [Sort<FeedsSortField>]?
    public let watch: Bool
    
    public init(
        filter: FeedsFilter? = nil,
        sort: [Sort<FeedsSortField>]? = nil,
        limit: Int? = nil,
        next: String? = nil,
        previous: String? = nil,
        watch: Bool = true
    ) {
        self.filter = filter
        self.limit = limit
        self.next = next
        self.previous = previous
        self.sort = sort
        self.watch = watch
    }
}

// MARK: - Filters

public struct FeedsFilterField: FilterFieldRepresentable, Sendable {
    public let value: String
    
    public init(value: String) {
        self.value = value
    }
    
    init(codingKey: FeedResponse.CodingKeys) {
        self.value = codingKey.rawValue
    }
}

extension FeedsFilterField {
    public static let id = Self(codingKey: .id)
    public static let groupId = Self(codingKey: .groupId)
    public static let fid = Self(codingKey: .fid)
    public static let createdAt = Self(codingKey: .createdAt)
    public static let createdById = Self(value: "created_by_id")
    public static let createdByName = Self(value: "created_by.name")
    public static let description = Self(codingKey: .description)
    public static let followerCount = Self(codingKey: .followerCount)
    public static let followingCount = Self(codingKey: .followingCount)
    public static let memberCount = Self(codingKey: .memberCount)
    public static let members = Self(value: "members")
    public static let name = Self(codingKey: .name)
    public static let updatedAt = Self(codingKey: .updatedAt)
    public static let visibility = Self(codingKey: .visibility)
    
}

public struct FeedsFilter: Filter {
    public init(filterOperator: FilterOperator, field: FeedsFilterField, value: any FilterValue) {
        self.filterOperator = filterOperator
        self.field = field
        self.value = value
    }
    
    public let field: FeedsFilterField
    public let value: any FilterValue
    public let filterOperator: FilterOperator
}

// MARK: - Sorting

public struct FeedsSortField: SortField {
    public let rawValue: String
    
    public static let createdAt: Self = "created_at"
    public static let popularity: Self = "popularity"
}

extension FeedsSortField: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        rawValue = value
    }
}

// MARK: -

extension FeedsQuery {
    func toRequest() -> QueryFeedsRequest {
        QueryFeedsRequest(
            filter: filter.flatMap { $0.toRawJSON() },
            limit: limit,
            next: next,
            prev: previous,
            sort: sort?.map { $0.toRequest() },
            watch: watch
        )
    }
}
