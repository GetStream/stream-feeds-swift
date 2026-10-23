//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class ModerationFlagResponse: Sendable, Codable, JSONEncodable {
    public let contentPublishedAt: Date?
    public let createdAt: Date
    public let custom: [String: RawJSON]?
    public let entityCreatorId: String?
    public let entityId: String
    public let entityType: String
    /// Unique identifier of the flag
    public let id: String?
    public let labels: [String]?
    /// Content payload for moderation
    public let moderationPayload: ModerationPayloadResponse?
    public let reason: String?
    public let result: [[String: RawJSON]]
    public let reviewQueueItem: ReviewQueueItemResponse?
    public let reviewQueueItemId: String?
    public let type: String
    public let updatedAt: Date
    /// User response object
    public let user: UserResponse?
    public let userId: String

    public init(contentPublishedAt: Date? = nil, createdAt: Date, custom: [String: RawJSON]? = nil, entityCreatorId: String? = nil, entityId: String, entityType: String, id: String? = nil, labels: [String]? = nil, moderationPayload: ModerationPayloadResponse? = nil, reason: String? = nil, result: [[String: RawJSON]], reviewQueueItem: ReviewQueueItemResponse? = nil, reviewQueueItemId: String? = nil, type: String, updatedAt: Date, user: UserResponse? = nil, userId: String) {
        self.contentPublishedAt = contentPublishedAt
        self.createdAt = createdAt
        self.custom = custom
        self.entityCreatorId = entityCreatorId
        self.entityId = entityId
        self.entityType = entityType
        self.id = id
        self.labels = labels
        self.moderationPayload = moderationPayload
        self.reason = reason
        self.result = result
        self.reviewQueueItem = reviewQueueItem
        self.reviewQueueItemId = reviewQueueItemId
        self.type = type
        self.updatedAt = updatedAt
        self.user = user
        self.userId = userId
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.contentPublishedAt = try container.decodeIfPresent(Date.self, forKey: .contentPublishedAt)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.custom = try container.decodeIfPresent([String: RawJSON].self, forKey: .custom)
        self.entityCreatorId = try container.decodeIfPresent(String.self, forKey: .entityCreatorId)
        self.entityId = try container.decode(String.self, forKey: .entityId)
        self.entityType = try container.decode(String.self, forKey: .entityType)
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.labels = try container.decodeIfPresent([String].self, forKey: .labels)
        self.moderationPayload = try container.decodeIfPresent(ModerationPayloadResponse.self, forKey: .moderationPayload)
        self.reason = try container.decodeIfPresent(String.self, forKey: .reason)
        self.result = try container.decode([[String: RawJSON]].self, forKey: .result)
        self.reviewQueueItem = try container.decodeIfPresent(ReviewQueueItemResponse.self, forKey: .reviewQueueItem)
        self.reviewQueueItemId = try container.decodeIfPresent(String.self, forKey: .reviewQueueItemId)
        self.type = try container.decode(String.self, forKey: .type)
        self.updatedAt = try container.decode(Date.self, forKey: .updatedAt)
        self.user = try container.decodeIfPresent(UserResponse.self, forKey: .user)
        self.userId = try container.decode(String.self, forKey: .userId)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(contentPublishedAt, forKey: .contentPublishedAt)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encodeIfPresent(custom, forKey: .custom)
        try container.encodeIfPresent(entityCreatorId, forKey: .entityCreatorId)
        try container.encode(entityId, forKey: .entityId)
        try container.encode(entityType, forKey: .entityType)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(labels, forKey: .labels)
        try container.encodeIfPresent(moderationPayload, forKey: .moderationPayload)
        try container.encodeIfPresent(reason, forKey: .reason)
        try container.encode(result, forKey: .result)
        try container.encodeIfPresent(reviewQueueItem, forKey: .reviewQueueItem)
        try container.encodeIfPresent(reviewQueueItemId, forKey: .reviewQueueItemId)
        try container.encode(type, forKey: .type)
        try container.encode(updatedAt, forKey: .updatedAt)
        try container.encodeIfPresent(user, forKey: .user)
        try container.encode(userId, forKey: .userId)
    }
}

extension ModerationFlagResponse: Hashable {
    public static func == (lhs: ModerationFlagResponse, rhs: ModerationFlagResponse) -> Bool {
        lhs.contentPublishedAt == rhs.contentPublishedAt &&
            lhs.createdAt == rhs.createdAt &&
            lhs.custom == rhs.custom &&
            lhs.entityCreatorId == rhs.entityCreatorId &&
            lhs.entityId == rhs.entityId &&
            lhs.entityType == rhs.entityType &&
            lhs.id == rhs.id &&
            lhs.labels == rhs.labels &&
            lhs.moderationPayload == rhs.moderationPayload &&
            lhs.reason == rhs.reason &&
            lhs.result == rhs.result &&
            lhs.reviewQueueItem == rhs.reviewQueueItem &&
            lhs.reviewQueueItemId == rhs.reviewQueueItemId &&
            lhs.type == rhs.type &&
            lhs.updatedAt == rhs.updatedAt &&
            lhs.user == rhs.user &&
            lhs.userId == rhs.userId
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(contentPublishedAt)
        hasher.combine(createdAt)
        hasher.combine(custom)
        hasher.combine(entityCreatorId)
        hasher.combine(entityId)
        hasher.combine(entityType)
        hasher.combine(id)
        hasher.combine(labels)
        hasher.combine(moderationPayload)
        hasher.combine(reason)
        hasher.combine(result)
        hasher.combine(reviewQueueItem)
        hasher.combine(reviewQueueItemId)
        hasher.combine(type)
        hasher.combine(updatedAt)
        hasher.combine(user)
        hasher.combine(userId)
    }
}
