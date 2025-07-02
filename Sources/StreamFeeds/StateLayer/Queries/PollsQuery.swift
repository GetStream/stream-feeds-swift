//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation

public struct PollsQuery: Sendable {
    public var filter: PollsFilter?
    public var limit: Int?
    public var next: String?
    public var previous: String?
    public var sort: [Sort<PollsSortField>]?

    public init(
        filter: PollsFilter? = nil,
        sort: [Sort<PollsSortField>]? = nil,
        limit: Int? = nil,
        next: String? = nil,
        previous: String? = nil
    ) {
        self.filter = filter
        self.limit = limit
        self.next = next
        self.previous = previous
        self.sort = sort
    }
}

// MARK: - Filters

public struct PollsFilterField: FilterFieldRepresentable, Sendable {
    public let value: String
    
    public init(value: String) {
        self.value = value
    }
    
    init(codingKey: PollResponseData.CodingKeys) {
        self.value = codingKey.rawValue
    }
}

extension PollsFilterField {
    public static let allowAnswers = Self(codingKey: .allowAnswers)
    public static let allowUserSuggestedOptions = Self(codingKey: .allowUserSuggestedOptions)
    public static let createdAt = Self(codingKey: .createdAt)
    public static let createdById = Self(value: "created_by_id")
    public static let id = Self(codingKey: .id)
    public static let isClosed = Self(codingKey: .isClosed)
    public static let maxVotesAllowed = Self(codingKey: .maxVotesAllowed)
    public static let pollId = Self(value: "poll_id")
    public static let name = Self(codingKey: .name)
    public static let updatedAt = Self(codingKey: .updatedAt)
    public static let voteCount = Self(codingKey: .voteCount)
    public static let votingVisibility = Self(codingKey: .votingVisibility)
}

public struct PollsFilter: Filter {
    public init(filterOperator: FilterOperator, field: PollsFilterField, value: any FilterValue) {
        self.filterOperator = filterOperator
        self.field = field
        self.value = value
    }
    
    public let field: PollsFilterField
    public let value: any FilterValue
    public let filterOperator: FilterOperator
}

// MARK: - Sorting

public struct PollsSortField: SortField {
    public typealias Model = PollData
    public let comparator: AnySortComparator<Model>
    public let remote: String
    
    public init<Value>(_ remote: String, localValue: @escaping @Sendable (Model) -> Value) where Value : Comparable {
        self.comparator = SortComparator(localValue).toAny()
        self.remote = remote
    }
    
    public static let createdAt = Self("created_at", localValue: \.createdAt)
    public static let updatedAt = Self("updated_at", localValue: \.updatedAt)
    public static let voteCount = Self("vote_count", localValue: \.voteCount)
    public static let name = Self("name", localValue: \.name)
}

extension Sort where Field == PollsSortField {
    static let defaultSorting = [Sort(field: .createdAt, direction: .reverse)]
}

// MARK: -

extension PollsQuery {
    func toRequest() -> QueryPollsRequest {
        QueryPollsRequest(
            filter: filter.flatMap { $0.toRawJSON() },
            limit: limit,
            next: next,
            prev: previous,
            sort: sort?.map { $0.toRequest() }
        )
    }
} 
