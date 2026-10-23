//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UpsertActivitiesResponse: Sendable, Codable, JSONEncodable {
    /// List of created or updated activities
    public let activities: [ActivityResponse]
    public let duration: String
    /// Total number of mention notification activities created for mentioned users across all activities
    public let mentionNotificationsCreated: Int?
    /// IDs of activities left unchanged because they already existed. Only set when skip_existing is true.
    public let skippedExisting: [String]?

    public init(activities: [ActivityResponse], duration: String, mentionNotificationsCreated: Int? = nil, skippedExisting: [String]? = nil) {
        self.activities = activities
        self.duration = duration
        self.mentionNotificationsCreated = mentionNotificationsCreated
        self.skippedExisting = skippedExisting
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.activities = try container.decode([ActivityResponse].self, forKey: .activities)
        self.duration = try container.decode(String.self, forKey: .duration)
        self.mentionNotificationsCreated = try container.decodeIfPresent(Int.self, forKey: .mentionNotificationsCreated)
        self.skippedExisting = try container.decodeIfPresent([String].self, forKey: .skippedExisting)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(activities, forKey: .activities)
        try container.encode(duration, forKey: .duration)
        try container.encodeIfPresent(mentionNotificationsCreated, forKey: .mentionNotificationsCreated)
        try container.encodeIfPresent(skippedExisting, forKey: .skippedExisting)
    }
}

extension UpsertActivitiesResponse: Hashable {
    public static func == (lhs: UpsertActivitiesResponse, rhs: UpsertActivitiesResponse) -> Bool {
        lhs.activities == rhs.activities &&
            lhs.duration == rhs.duration &&
            lhs.mentionNotificationsCreated == rhs.mentionNotificationsCreated &&
            lhs.skippedExisting == rhs.skippedExisting
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(activities)
        hasher.combine(duration)
        hasher.combine(mentionNotificationsCreated)
        hasher.combine(skippedExisting)
    }
}
