//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class ActionLogResponse: @unchecked Sendable, Codable, JSONEncodable {
    public var aiProviders: [String]
    /// Timestamp when the action was taken
    public var createdAt: Date
    /// Additional metadata about the action
    public var custom: [String: RawJSON]
    /// Unique identifier of the action log
    public var id: String
    /// Reason for the moderation action
    public var reason: String
    /// Classification of who triggered the action (e.g. user, moderator, automod, api_integration)
    public var reporterType: String
    public var reviewQueueItem: ReviewQueueItemResponse?
    /// User response object
    public var targetUser: UserResponse?
    /// ID of the user who was the target of the action
    public var targetUserId: String
    /// Type of moderation action
    public var type: String
    /// User response object
    public var user: UserResponse?
    /// ID of the user who performed the action
    public var userId: String

    public init(aiProviders: [String], createdAt: Date, custom: [String: RawJSON], id: String, reason: String, reporterType: String, reviewQueueItem: ReviewQueueItemResponse? = nil, targetUser: UserResponse? = nil, targetUserId: String, type: String, user: UserResponse? = nil, userId: String) {
        self.aiProviders = aiProviders
        self.createdAt = createdAt
        self.custom = custom
        self.id = id
        self.reason = reason
        self.reporterType = reporterType
        self.reviewQueueItem = reviewQueueItem
        self.targetUser = targetUser
        self.targetUserId = targetUserId
        self.type = type
        self.user = user
        self.userId = userId
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case aiProviders = "ai_providers"
        case createdAt = "created_at"
        case custom
        case id
        case reason
        case reporterType = "reporter_type"
        case reviewQueueItem = "review_queue_item"
        case targetUser = "target_user"
        case targetUserId = "target_user_id"
        case type
        case user
        case userId = "user_id"
    }
}

extension ActionLogResponse: Hashable {
    public static func == (lhs: ActionLogResponse, rhs: ActionLogResponse) -> Bool {
        lhs.aiProviders == rhs.aiProviders &&
            lhs.createdAt == rhs.createdAt &&
            lhs.custom == rhs.custom &&
            lhs.id == rhs.id &&
            lhs.reason == rhs.reason &&
            lhs.reporterType == rhs.reporterType &&
            lhs.reviewQueueItem == rhs.reviewQueueItem &&
            lhs.targetUser == rhs.targetUser &&
            lhs.targetUserId == rhs.targetUserId &&
            lhs.type == rhs.type &&
            lhs.user == rhs.user &&
            lhs.userId == rhs.userId
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(aiProviders)
        hasher.combine(createdAt)
        hasher.combine(custom)
        hasher.combine(id)
        hasher.combine(reason)
        hasher.combine(reporterType)
        hasher.combine(reviewQueueItem)
        hasher.combine(targetUser)
        hasher.combine(targetUserId)
        hasher.combine(type)
        hasher.combine(user)
        hasher.combine(userId)
    }
}
