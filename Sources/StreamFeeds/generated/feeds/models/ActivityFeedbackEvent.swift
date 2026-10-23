//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Emitted when activity feedback is provided.
public final class ActivityFeedbackEvent: Sendable, Event, Codable, JSONEncodable {
    public let activityFeedback: ActivityFeedbackEventPayload
    /// Date/time of creation
    public let createdAt: Date
    public let custom: [String: RawJSON]
    public let receivedAt: Date?
    /// The type of event: "feeds.activity.feedback" in this case
    public let type: String
    public let user: UserResponseCommonFields?

    public init(activityFeedback: ActivityFeedbackEventPayload, createdAt: Date, custom: [String: RawJSON], receivedAt: Date? = nil, type: String = "feeds.activity.feedback", user: UserResponseCommonFields? = nil) {
        self.activityFeedback = activityFeedback
        self.createdAt = createdAt
        self.custom = custom
        self.receivedAt = receivedAt
        self.type = type
        self.user = user
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.activityFeedback = try container.decode(ActivityFeedbackEventPayload.self, forKey: .activityFeedback)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.custom = try container.decode([String: RawJSON].self, forKey: .custom)
        self.receivedAt = try container.decodeIfPresent(Date.self, forKey: .receivedAt)
        self.type = try container.decode(String.self, forKey: .type)
        self.user = try container.decodeIfPresent(UserResponseCommonFields.self, forKey: .user)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(activityFeedback, forKey: .activityFeedback)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(custom, forKey: .custom)
        try container.encodeIfPresent(receivedAt, forKey: .receivedAt)
        try container.encode(type, forKey: .type)
        try container.encodeIfPresent(user, forKey: .user)
    }
}

extension ActivityFeedbackEvent: Hashable {
    public static func == (lhs: ActivityFeedbackEvent, rhs: ActivityFeedbackEvent) -> Bool {
        lhs.activityFeedback == rhs.activityFeedback &&
            lhs.createdAt == rhs.createdAt &&
            lhs.custom == rhs.custom &&
            lhs.receivedAt == rhs.receivedAt &&
            lhs.type == rhs.type &&
            lhs.user == rhs.user
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(activityFeedback)
        hasher.combine(createdAt)
        hasher.combine(custom)
        hasher.combine(receivedAt)
        hasher.combine(type)
        hasher.combine(user)
    }
}
