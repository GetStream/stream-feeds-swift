//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class Flag: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var createdAt: Date
    public var custom: [String: RawJSON]?
    public var entityCreatorId: String?
    public var entityId: String
    public var entityType: String
    public var isStreamedContent: Bool?
    public var labels: [String]?
    public var moderationPayload: ModerationPayload?
    public var moderationPayloadHash: String?
    public var reason: String?
    public var result: [[String: RawJSON]]
    public var reviewQueueItem: ReviewQueueItem?
    public var reviewQueueItemId: String?
    public var type: String?
    public var updatedAt: Date
    public var user: User?

    public init(createdAt: Date, custom: [String: RawJSON]? = nil, entityCreatorId: String? = nil, entityId: String, entityType: String, isStreamedContent: Bool? = nil, labels: [String]? = nil, moderationPayload: ModerationPayload? = nil, moderationPayloadHash: String? = nil, reason: String? = nil, result: [[String: RawJSON]], reviewQueueItem: ReviewQueueItem? = nil, reviewQueueItemId: String? = nil, updatedAt: Date, user: User? = nil) {
        self.createdAt = createdAt
        self.custom = custom
        self.entityCreatorId = entityCreatorId
        self.entityId = entityId
        self.entityType = entityType
        self.isStreamedContent = isStreamedContent
        self.labels = labels
        self.moderationPayload = moderationPayload
        self.moderationPayloadHash = moderationPayloadHash
        self.reason = reason
        self.result = result
        self.reviewQueueItem = reviewQueueItem
        self.reviewQueueItemId = reviewQueueItemId
        self.updatedAt = updatedAt
        self.user = user
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case createdAt = "created_at"
        case custom
        case entityCreatorId = "entity_creator_id"
        case entityId = "entity_id"
        case entityType = "entity_type"
        case isStreamedContent = "is_streamed_content"
        case labels
        case moderationPayload = "moderation_payload"
        case moderationPayloadHash = "moderation_payload_hash"
        case reason
        case result
        case reviewQueueItem = "review_queue_item"
        case reviewQueueItemId = "review_queue_item_id"
        case type
        case updatedAt = "updated_at"
        case user
    }

    public static func == (lhs: Flag, rhs: Flag) -> Bool {
        lhs.createdAt == rhs.createdAt &&
            lhs.custom == rhs.custom &&
            lhs.entityCreatorId == rhs.entityCreatorId &&
            lhs.entityId == rhs.entityId &&
            lhs.entityType == rhs.entityType &&
            lhs.isStreamedContent == rhs.isStreamedContent &&
            lhs.labels == rhs.labels &&
            lhs.moderationPayload == rhs.moderationPayload &&
            lhs.moderationPayloadHash == rhs.moderationPayloadHash &&
            lhs.reason == rhs.reason &&
            lhs.result == rhs.result &&
            lhs.reviewQueueItem == rhs.reviewQueueItem &&
            lhs.reviewQueueItemId == rhs.reviewQueueItemId &&
            lhs.type == rhs.type &&
            lhs.updatedAt == rhs.updatedAt &&
            lhs.user == rhs.user
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(createdAt)
        hasher.combine(custom)
        hasher.combine(entityCreatorId)
        hasher.combine(entityId)
        hasher.combine(entityType)
        hasher.combine(isStreamedContent)
        hasher.combine(labels)
        hasher.combine(moderationPayload)
        hasher.combine(moderationPayloadHash)
        hasher.combine(reason)
        hasher.combine(result)
        hasher.combine(reviewQueueItem)
        hasher.combine(reviewQueueItemId)
        hasher.combine(type)
        hasher.combine(updatedAt)
        hasher.combine(user)
    }
}
