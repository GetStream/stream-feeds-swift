//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class ActivityFeedbackEventPayloadAction: RawRepresentable, Codable, Hashable, Sendable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public static let hide = ActivityFeedbackEventPayloadAction(rawValue: "hide")
    public static let showLess = ActivityFeedbackEventPayloadAction(rawValue: "show_less")
    public static let showMore = ActivityFeedbackEventPayloadAction(rawValue: "show_more")
}

public final class ActivityFeedbackEventPayload: Sendable, Codable, JSONEncodable {
    /// The type of feedback action. One of: hide, show_more, show_less
    public let action: ActivityFeedbackEventPayloadAction
    /// The activity that received feedback
    public let activityId: String
    /// When the feedback was created
    public let createdAt: Date
    /// When the feedback was last updated
    public let updatedAt: Date
    /// User response object
    public let user: UserResponse
    /// The feedback value (true/false)
    public let value: String

    public init(action: ActivityFeedbackEventPayloadAction, activityId: String, createdAt: Date, updatedAt: Date, user: UserResponse, value: String) {
        self.action = action
        self.activityId = activityId
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.user = user
        self.value = value
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.action = try container.decode(ActivityFeedbackEventPayloadAction.self, forKey: .action)
        self.activityId = try container.decode(String.self, forKey: .activityId)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.updatedAt = try container.decode(Date.self, forKey: .updatedAt)
        self.user = try container.decode(UserResponse.self, forKey: .user)
        self.value = try container.decode(String.self, forKey: .value)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(action, forKey: .action)
        try container.encode(activityId, forKey: .activityId)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(updatedAt, forKey: .updatedAt)
        try container.encode(user, forKey: .user)
        try container.encode(value, forKey: .value)
    }
}

extension ActivityFeedbackEventPayload: Hashable {
    public static func == (lhs: ActivityFeedbackEventPayload, rhs: ActivityFeedbackEventPayload) -> Bool {
        lhs.action == rhs.action &&
            lhs.activityId == rhs.activityId &&
            lhs.createdAt == rhs.createdAt &&
            lhs.updatedAt == rhs.updatedAt &&
            lhs.user == rhs.user &&
            lhs.value == rhs.value
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(action)
        hasher.combine(activityId)
        hasher.combine(createdAt)
        hasher.combine(updatedAt)
        hasher.combine(user)
        hasher.combine(value)
    }
}
