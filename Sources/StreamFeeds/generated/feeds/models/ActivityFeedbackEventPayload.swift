//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class ActivityFeedbackEventPayload: @unchecked Sendable, Codable, JSONEncodable {
    public enum ActivityFeedbackEventPayloadAction: String, Sendable, Codable, CaseIterable {
        case hide
        case showLess = "show_less"
        case showMore = "show_more"
        case unknown = "_unknown"

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let decodedValue = try? container.decode(String.self),
               let value = Self(rawValue: decodedValue) {
                self = value
            } else {
                self = .unknown
            }
        }
    }

    /// The type of feedback action. One of: hide, show_more, show_less
    public var action: ActivityFeedbackEventPayloadAction
    /// The activity that received feedback
    public var activityId: String
    /// When the feedback was created
    public var createdAt: Date
    /// When the feedback was last updated
    public var updatedAt: Date
    /// User response object
    public var user: UserResponse
    /// The feedback value (true/false)
    public var value: String

    public init(action: ActivityFeedbackEventPayloadAction, activityId: String, createdAt: Date, updatedAt: Date, user: UserResponse, value: String) {
        self.action = action
        self.activityId = activityId
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.user = user
        self.value = value
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case action
        case activityId = "activity_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case user
        case value
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
