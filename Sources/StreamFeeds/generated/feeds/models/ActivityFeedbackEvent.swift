//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class ActivityFeedbackEvent: @unchecked Sendable,  Event, Codable, JSONEncodable, Hashable {
    public var activityFeedback: ActivityFeedbackEventPayload
    public var createdAt: Date
    public var custom: [String: RawJSON]
    public var receivedAt: Date?
    public var type: String = "feeds.activity.feedback"
    public var user: UserResponseCommonFields?

    public init(activityFeedback: ActivityFeedbackEventPayload, createdAt: Date, custom: [String: RawJSON], receivedAt: Date? = nil, user: UserResponseCommonFields? = nil) {
        self.activityFeedback = activityFeedback
        self.createdAt = createdAt
        self.custom = custom
        self.receivedAt = receivedAt
        self.user = user
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case activityFeedback = "activity_feedback"
        case createdAt = "created_at"
        case custom
        case receivedAt = "received_at"
        case type
        case user
    }

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
