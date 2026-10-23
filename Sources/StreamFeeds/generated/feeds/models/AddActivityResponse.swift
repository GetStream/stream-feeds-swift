//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class AddActivityResponse: @unchecked Sendable, Codable, JSONEncodable {
    public var activity: ActivityResponse
    public var duration: String
    /// Number of mention notification activities created for mentioned users
    public var mentionNotificationsCreated: Int?
    /// Contains the activity ID when skip_existing is true and the activity already existed, so it was left unchanged.
    public var skippedExisting: [String]?

    public init(activity: ActivityResponse, duration: String, mentionNotificationsCreated: Int? = nil, skippedExisting: [String]? = nil) {
        self.activity = activity
        self.duration = duration
        self.mentionNotificationsCreated = mentionNotificationsCreated
        self.skippedExisting = skippedExisting
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case activity
        case duration
        case mentionNotificationsCreated = "mention_notifications_created"
        case skippedExisting = "skipped_existing"
    }
}

extension AddActivityResponse: Hashable {
    public static func == (lhs: AddActivityResponse, rhs: AddActivityResponse) -> Bool {
        lhs.activity == rhs.activity &&
            lhs.duration == rhs.duration &&
            lhs.mentionNotificationsCreated == rhs.mentionNotificationsCreated &&
            lhs.skippedExisting == rhs.skippedExisting
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(activity)
        hasher.combine(duration)
        hasher.combine(mentionNotificationsCreated)
        hasher.combine(skippedExisting)
    }
}
