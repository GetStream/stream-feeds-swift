//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class ActionLogResponse: Sendable, Codable, JSONEncodable {
    public let aiProviders: [String]
    /// Timestamp when the action was taken
    public let createdAt: Date
    /// Additional metadata about the action
    public let custom: [String: RawJSON]
    /// Unique identifier of the action log
    public let id: String
    /// Reason for the moderation action
    public let reason: String
    public let reviewQueueItem: ReviewQueueItemResponse?
    /// User response object
    public let targetUser: UserResponse?
    /// ID of the user who was the target of the action
    public let targetUserId: String
    /// Type of moderation action
    public let type: String
    /// User response object
    public let user: UserResponse?
    /// ID of the user who performed the action
    public let userId: String

    public init(aiProviders: [String], createdAt: Date, custom: [String: RawJSON], id: String, reason: String, reviewQueueItem: ReviewQueueItemResponse? = nil, targetUser: UserResponse? = nil, targetUserId: String, type: String, user: UserResponse? = nil, userId: String) {
        self.aiProviders = aiProviders
        self.createdAt = createdAt
        self.custom = custom
        self.id = id
        self.reason = reason
        self.reviewQueueItem = reviewQueueItem
        self.targetUser = targetUser
        self.targetUserId = targetUserId
        self.type = type
        self.user = user
        self.userId = userId
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.aiProviders = try container.decode([String].self, forKey: .aiProviders)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.custom = try container.decode([String: RawJSON].self, forKey: .custom)
        self.id = try container.decode(String.self, forKey: .id)
        self.reason = try container.decode(String.self, forKey: .reason)
        self.reviewQueueItem = try container.decodeIfPresent(ReviewQueueItemResponse.self, forKey: .reviewQueueItem)
        self.targetUser = try container.decodeIfPresent(UserResponse.self, forKey: .targetUser)
        self.targetUserId = try container.decode(String.self, forKey: .targetUserId)
        self.type = try container.decode(String.self, forKey: .type)
        self.user = try container.decodeIfPresent(UserResponse.self, forKey: .user)
        self.userId = try container.decode(String.self, forKey: .userId)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(aiProviders, forKey: .aiProviders)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(custom, forKey: .custom)
        try container.encode(id, forKey: .id)
        try container.encode(reason, forKey: .reason)
        try container.encodeIfPresent(reviewQueueItem, forKey: .reviewQueueItem)
        try container.encodeIfPresent(targetUser, forKey: .targetUser)
        try container.encode(targetUserId, forKey: .targetUserId)
        try container.encode(type, forKey: .type)
        try container.encodeIfPresent(user, forKey: .user)
        try container.encode(userId, forKey: .userId)
    }
}

extension ActionLogResponse: Hashable {
    public static func == (lhs: ActionLogResponse, rhs: ActionLogResponse) -> Bool {
        lhs.aiProviders == rhs.aiProviders &&
            lhs.createdAt == rhs.createdAt &&
            lhs.custom == rhs.custom &&
            lhs.id == rhs.id &&
            lhs.reason == rhs.reason &&
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
        hasher.combine(reviewQueueItem)
        hasher.combine(targetUser)
        hasher.combine(targetUserId)
        hasher.combine(type)
        hasher.combine(user)
        hasher.combine(userId)
    }
}
