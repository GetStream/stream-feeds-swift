//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class ReviewQueueItemResponse: Sendable, Decodable {
    /// Moderation actions taken
    public let actions: [ActionLogResponse]
    public let activity: EnrichedActivity?
    /// AI-determined text severity
    public let aiTextSeverity: String
    /// User response object
    public let assignedTo: UserResponse?
    /// Associated ban records
    public let bans: [BanInfoResponse]
    /// When the review was completed
    public let completedAt: Date?
    public let configKey: String?
    /// When the item was created
    public let createdAt: Date
    public let entityCreator: EntityCreatorResponse?
    /// ID of who created the entity
    public let entityCreatorId: String?
    /// ID of the entity being reviewed
    public let entityId: String
    /// Type of entity being reviewed
    public let entityType: String
    public let feedsV2Activity: EnrichedActivity?
    /// Associated flag records
    public let flags: [ModerationFlagResponse]
    public let flagsCount: Int
    /// Unique identifier of the review queue item
    public let id: String
    /// Detected languages in the content
    public let languages: [String]
    /// Content payload for moderation
    public let moderationPayload: ModerationPayloadResponse?
    /// Suggested moderation action
    public let recommendedAction: String
    /// When the item was reviewed
    public let reviewedAt: Date?
    /// ID of the moderator who reviewed the item
    public let reviewedBy: String
    /// Severity level of the content
    public let severity: Int
    /// Current status of the review
    public let status: String
    /// Teams associated with this item
    public let teams: [String]?
    /// When the item was last updated
    public let updatedAt: Date

    public init(actions: [ActionLogResponse], activity: EnrichedActivity? = nil, aiTextSeverity: String, assignedTo: UserResponse? = nil, bans: [BanInfoResponse], completedAt: Date? = nil, configKey: String? = nil, createdAt: Date, entityCreator: EntityCreatorResponse? = nil, entityCreatorId: String? = nil, entityId: String, entityType: String, feedsV2Activity: EnrichedActivity? = nil, flags: [ModerationFlagResponse], flagsCount: Int, id: String, languages: [String], moderationPayload: ModerationPayloadResponse? = nil, recommendedAction: String, reviewedAt: Date? = nil, reviewedBy: String, severity: Int, status: String, teams: [String]? = nil, updatedAt: Date) {
        self.actions = actions
        self.activity = activity
        self.aiTextSeverity = aiTextSeverity
        self.assignedTo = assignedTo
        self.bans = bans
        self.completedAt = completedAt
        self.configKey = configKey
        self.createdAt = createdAt
        self.entityCreator = entityCreator
        self.entityCreatorId = entityCreatorId
        self.entityId = entityId
        self.entityType = entityType
        self.feedsV2Activity = feedsV2Activity
        self.flags = flags
        self.flagsCount = flagsCount
        self.id = id
        self.languages = languages
        self.moderationPayload = moderationPayload
        self.recommendedAction = recommendedAction
        self.reviewedAt = reviewedAt
        self.reviewedBy = reviewedBy
        self.severity = severity
        self.status = status
        self.teams = teams
        self.updatedAt = updatedAt
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.actions = try container.decode([ActionLogResponse].self, forKey: .actions)
        self.activity = try container.decodeIfPresent(EnrichedActivity.self, forKey: .activity)
        self.aiTextSeverity = try container.decode(String.self, forKey: .aiTextSeverity)
        self.assignedTo = try container.decodeIfPresent(UserResponse.self, forKey: .assignedTo)
        self.bans = try container.decode([BanInfoResponse].self, forKey: .bans)
        self.completedAt = try container.decodeIfPresent(Date.self, forKey: .completedAt)
        self.configKey = try container.decodeIfPresent(String.self, forKey: .configKey)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.entityCreator = try container.decodeIfPresent(EntityCreatorResponse.self, forKey: .entityCreator)
        self.entityCreatorId = try container.decodeIfPresent(String.self, forKey: .entityCreatorId)
        self.entityId = try container.decode(String.self, forKey: .entityId)
        self.entityType = try container.decode(String.self, forKey: .entityType)
        self.feedsV2Activity = try container.decodeIfPresent(EnrichedActivity.self, forKey: .feedsV2Activity)
        self.flags = try container.decode([ModerationFlagResponse].self, forKey: .flags)
        self.flagsCount = try container.decode(Int.self, forKey: .flagsCount)
        self.id = try container.decode(String.self, forKey: .id)
        self.languages = try container.decode([String].self, forKey: .languages)
        self.moderationPayload = try container.decodeIfPresent(ModerationPayloadResponse.self, forKey: .moderationPayload)
        self.recommendedAction = try container.decode(String.self, forKey: .recommendedAction)
        self.reviewedAt = try container.decodeIfPresent(Date.self, forKey: .reviewedAt)
        self.reviewedBy = try container.decode(String.self, forKey: .reviewedBy)
        self.severity = try container.decode(Int.self, forKey: .severity)
        self.status = try container.decode(String.self, forKey: .status)
        self.teams = try container.decodeIfPresent([String].self, forKey: .teams)
        self.updatedAt = try container.decode(Date.self, forKey: .updatedAt)
    }
}

extension ReviewQueueItemResponse: Hashable {
    public static func == (lhs: ReviewQueueItemResponse, rhs: ReviewQueueItemResponse) -> Bool {
        lhs.actions == rhs.actions &&
            lhs.activity == rhs.activity &&
            lhs.aiTextSeverity == rhs.aiTextSeverity &&
            lhs.assignedTo == rhs.assignedTo &&
            lhs.bans == rhs.bans &&
            lhs.completedAt == rhs.completedAt &&
            lhs.configKey == rhs.configKey &&
            lhs.createdAt == rhs.createdAt &&
            lhs.entityCreator == rhs.entityCreator &&
            lhs.entityCreatorId == rhs.entityCreatorId &&
            lhs.entityId == rhs.entityId &&
            lhs.entityType == rhs.entityType &&
            lhs.feedsV2Activity == rhs.feedsV2Activity &&
            lhs.flags == rhs.flags &&
            lhs.flagsCount == rhs.flagsCount &&
            lhs.id == rhs.id &&
            lhs.languages == rhs.languages &&
            lhs.moderationPayload == rhs.moderationPayload &&
            lhs.recommendedAction == rhs.recommendedAction &&
            lhs.reviewedAt == rhs.reviewedAt &&
            lhs.reviewedBy == rhs.reviewedBy &&
            lhs.severity == rhs.severity &&
            lhs.status == rhs.status &&
            lhs.teams == rhs.teams &&
            lhs.updatedAt == rhs.updatedAt
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(actions)
        hasher.combine(activity)
        hasher.combine(aiTextSeverity)
        hasher.combine(assignedTo)
        hasher.combine(bans)
        hasher.combine(completedAt)
        hasher.combine(configKey)
        hasher.combine(createdAt)
        hasher.combine(entityCreator)
        hasher.combine(entityCreatorId)
        hasher.combine(entityId)
        hasher.combine(entityType)
        hasher.combine(feedsV2Activity)
        hasher.combine(flags)
        hasher.combine(flagsCount)
        hasher.combine(id)
        hasher.combine(languages)
        hasher.combine(moderationPayload)
        hasher.combine(recommendedAction)
        hasher.combine(reviewedAt)
        hasher.combine(reviewedBy)
        hasher.combine(severity)
        hasher.combine(status)
        hasher.combine(teams)
        hasher.combine(updatedAt)
    }
}
