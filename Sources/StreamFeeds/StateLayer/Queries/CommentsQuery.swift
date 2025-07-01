//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public struct CommentsQuery: Sendable {
    public var filter: [CommentsFilterField: [String]]
    public var limit: Int?
    public var next: String?
    public var previous: String?
    public var sort: CommentsSort?

    public init(
        filter: [CommentsFilterField: [String]],
        sort: CommentsSort? = nil,
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

public struct CommentsFilterField: FilterFieldRepresentable, Hashable, Sendable {
    public let value: String
    
    public init(value: String) {
        self.value = value
    }
}

extension CommentsFilterField {
    public static let activityIds = Self(value: "activity_ids")
    public static let userIds = Self(value: "user_id")
    public static let parentIds = Self(value: "parent_ids")
}

// MARK: - Sorting

public typealias CommentsSort = QueryCommentsRequest.string

// MARK: -

extension CommentsQuery {
    func toRequest() -> QueryCommentsRequest {
        let filterPairs = self.filter
            .map { keyValue in
                let rawJSONArray = keyValue.value.map { RawJSON.string($0) }
                return (keyValue.key.value, RawJSON.array(rawJSONArray))
            }
        let filter = Dictionary(uniqueKeysWithValues: filterPairs)
        return QueryCommentsRequest(
            filter: filter,
            limit: limit,
            next: next,
            prev: previous,
            sort: sort?.rawValue
        )
    }
} 
