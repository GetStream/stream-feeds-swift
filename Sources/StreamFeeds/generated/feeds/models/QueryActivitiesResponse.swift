//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class QueryActivitiesResponse: @unchecked Sendable, Codable, JSONEncodable {
    /// List of activities matching the query
    public var activities: [ActivityResponse]
    public var duration: String
    /// Cursor for next page
    public var next: String?
    /// Cursor for previous page
    public var prev: String?

    public init(
        activities: [ActivityResponse],
        duration: String,
        next: String? = nil,
        prev: String? = nil
    ) {
        self.activities = activities
        self.duration = duration
        self.next = next
        self.prev = prev
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case activities
        case duration
        case next
        case prev
    }
}

extension QueryActivitiesResponse: Hashable {
    public static func == (lhs: QueryActivitiesResponse, rhs: QueryActivitiesResponse) -> Bool {
        lhs.activities == rhs.activities &&
            lhs.duration == rhs.duration &&
            lhs.next == rhs.next &&
            lhs.prev == rhs.prev
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(activities)
        hasher.combine(duration)
        hasher.combine(next)
        hasher.combine(prev)
    }
}
