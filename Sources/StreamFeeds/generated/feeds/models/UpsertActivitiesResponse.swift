//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UpsertActivitiesResponse: @unchecked Sendable, Codable, JSONEncodable {
    /// List of created or updated activities
    public var activities: [ActivityResponse]
    public var duration: String
    /// Total number of mention notification activities created for mentioned users across all activities
    public var mentionNotificationsCreated: Int?
    /// IDs of activities left unchanged because they already existed. Only set when skip_existing is true.
    public var skippedExisting: [String]?

    public init(
        activities: [ActivityResponse],
        duration: String,
        mentionNotificationsCreated: Int? = nil,
        skippedExisting: [String]? = nil
    ) {
        self.activities = activities
        self.duration = duration
        self.mentionNotificationsCreated = mentionNotificationsCreated
        self.skippedExisting = skippedExisting
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case activities
        case duration
        case mentionNotificationsCreated = "mention_notifications_created"
        case skippedExisting = "skipped_existing"
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
