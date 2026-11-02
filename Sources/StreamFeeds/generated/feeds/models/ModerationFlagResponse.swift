//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class ModerationFlagResponse: Sendable, Decodable {
    public let createdAt: Date
    public let custom: [String: RawJSON]?
    public let entityCreatorId: String?
    public let entityId: String
    public let entityType: String
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

    public init(createdAt: Date, custom: [String: RawJSON]? = nil, entityCreatorId: String? = nil, entityId: String, entityType: String, labels: [String]? = nil, moderationPayload: ModerationPayloadResponse? = nil, reason: String? = nil, result: [[String: RawJSON]], reviewQueueItem: ReviewQueueItemResponse? = nil, reviewQueueItemId: String? = nil, type: String, updatedAt: Date, user: UserResponse? = nil, userId: String) {
        self.createdAt = createdAt
        self.custom = custom
        self.entityCreatorId = entityCreatorId
        self.entityId = entityId
        self.entityType = entityType
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
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.custom = try container.decodeIfPresent([String: RawJSON].self, forKey: .custom)
        self.entityCreatorId = try container.decodeIfPresent(String.self, forKey: .entityCreatorId)
        self.entityId = try container.decode(String.self, forKey: .entityId)
        self.entityType = try container.decode(String.self, forKey: .entityType)
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
}

extension ModerationFlagResponse: Hashable {
    public static func == (lhs: ModerationFlagResponse, rhs: ModerationFlagResponse) -> Bool {
        lhs.createdAt == rhs.createdAt &&
            lhs.custom == rhs.custom &&
            lhs.entityCreatorId == rhs.entityCreatorId &&
            lhs.entityId == rhs.entityId &&
            lhs.entityType == rhs.entityType &&
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
        hasher.combine(createdAt)
        hasher.combine(custom)
        hasher.combine(entityCreatorId)
        hasher.combine(entityId)
        hasher.combine(entityType)
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
