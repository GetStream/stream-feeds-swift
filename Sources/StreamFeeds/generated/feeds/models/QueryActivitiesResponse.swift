//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class QueryActivitiesResponse: Sendable, Codable, JSONEncodable {
    /// List of activities matching the query
    public let activities: [ActivityResponse]
    public let duration: String
    /// Cursor for next page
    public let next: String?
    /// Cursor for previous page
    public let prev: String?

    public init(activities: [ActivityResponse], duration: String, next: String? = nil, prev: String? = nil) {
        self.activities = activities
        self.duration = duration
        self.next = next
        self.prev = prev
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.activities = try container.decode([ActivityResponse].self, forKey: .activities)
        self.duration = try container.decode(String.self, forKey: .duration)
        self.next = try container.decodeIfPresent(String.self, forKey: .next)
        self.prev = try container.decodeIfPresent(String.self, forKey: .prev)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(activities, forKey: .activities)
        try container.encode(duration, forKey: .duration)
        try container.encodeIfPresent(next, forKey: .next)
        try container.encodeIfPresent(prev, forKey: .prev)
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
