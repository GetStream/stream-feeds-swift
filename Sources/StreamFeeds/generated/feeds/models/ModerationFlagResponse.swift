//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class ModerationFlagResponse: @unchecked Sendable, Codable, JSONEncodable {
    public var contentPublishedAt: Date?
    public var createdAt: Date
    public var custom: [String: RawJSON]?
    public var entityCreatorId: String?
    public var entityId: String
    public var entityType: String
    /// Unique identifier of the flag
    public var id: String?
    public var labels: [String]?
    /// Content payload for moderation
    public var moderationPayload: ModerationPayloadResponse?
    public var reason: String?
    public var result: [[String: RawJSON]]
    public var reviewQueueItem: ReviewQueueItemResponse?
    public var reviewQueueItemId: String?
    public var type: String
    public var updatedAt: Date
    /// User response object
    public var user: UserResponse?
    public var userId: String

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

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case contentPublishedAt = "content_published_at"
        case createdAt = "created_at"
        case custom
        case entityCreatorId = "entity_creator_id"
        case entityId = "entity_id"
        case entityType = "entity_type"
        case id
        case labels
        case moderationPayload = "moderation_payload"
        case reason
        case result
        case reviewQueueItem = "review_queue_item"
        case reviewQueueItemId = "review_queue_item_id"
        case type
        case updatedAt = "updated_at"
        case user
        case userId = "user_id"
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
