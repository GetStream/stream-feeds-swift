//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation

public struct PollVotesQuery: Sendable {
    public var pollId: String
    public var userId: String?
    public var filter: PollVotesFilter?
    public var limit: Int?
    public var next: String?
    public var previous: String?
    public var sort: [Sort<PollVotesSortField>]?

    public init(
        pollId: String,
        userId: String? = nil,
        filter: PollVotesFilter? = nil,
        sort: [Sort<PollVotesSortField>]? = nil,
        limit: Int? = nil,
        next: String? = nil,
        previous: String? = nil
    ) {
        self.filter = filter
        self.limit = limit
        self.next = next
        self.previous = previous
        self.pollId = pollId
        self.sort = sort
        self.userId = userId
    }
}

// MARK: - Filters

public struct PollVotesFilterField: FilterFieldRepresentable, Sendable {
    public let value: String
    
    public init(value: String) {
        self.value = value
    }
    
    init(codingKey: PollVoteResponseData.CodingKeys) {
        self.value = codingKey.rawValue
    }
}

extension PollVotesFilterField {
    public static let createdAt = Self(codingKey: .createdAt)
    public static let id = Self(codingKey: .id)
    public static let isAnswer = Self(value: "is_answer")
    public static let optionId = Self(value: "option_id")
    public static let userId = Self(value: "user_id")
}

public struct PollVotesFilter: Filter {
    public init(filterOperator: FilterOperator, field: PollVotesFilterField, value: any FilterValue) {
        self.filterOperator = filterOperator
        self.field = field
        self.value = value
    }
    
    public let field: PollVotesFilterField
    public let value: any FilterValue
    public let filterOperator: FilterOperator
}

// MARK: - Sorting

public struct PollVotesSortField: SortField {
    public typealias Model = PollVoteData
    public let comparator: AnySortComparator<Model>
    public let remote: String
    
    public init<Value>(_ remote: String, localValue: @escaping @Sendable (Model) -> Value) where Value : Comparable {
        self.comparator = SortComparator(localValue).toAny()
        self.remote = remote
    }
    
    public static let createdAt = Self("created_at", localValue: \.createdAt)
    public static let updatedAt = Self("updated_at", localValue: \.updatedAt)
}

extension Sort where Field == PollVotesSortField {
    static let defaultSorting = [Sort(field: .createdAt, direction: .reverse)]
}

// MARK: -

extension PollVotesQuery {
    func toRequest() -> QueryPollVotesRequest {
        QueryPollVotesRequest(
            filter: filter.flatMap { $0.toRawJSON() },
            limit: limit,
            next: next,
            prev: previous,
            sort: sort?.map { $0.toRequest() }
        )
    }
} 
