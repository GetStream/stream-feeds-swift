//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class ReviewQueueItemResponse: @unchecked Sendable, Codable, JSONEncodable {
    /// Moderation actions taken
    public var actions: [ActionLogResponse]
    public var activity: EnrichedActivity?
    /// AI-determined text severity
    public var aiTextSeverity: String
    /// User response object
    public var assignedTo: UserResponse?
    /// Associated ban records
    public var bans: [BanInfoResponse]
    /// When the review was completed
    public var completedAt: Date?
    public var configKey: String?
    /// When the item was created
    public var createdAt: Date
    public var entityCreator: EntityCreatorResponse?
    /// ID of who created the entity
    public var entityCreatorId: String?
    /// ID of the entity being reviewed
    public var entityId: String
    /// Type of entity being reviewed
    public var entityType: String
    public var feedsV2Activity: EnrichedActivity?
    /// Associated flag records
    public var flags: [ModerationFlagResponse]
    public var flagsCount: Int
    /// Unique identifier of the review queue item
    public var id: String
    /// Detected languages in the content
    public var languages: [String]
    /// Content payload for moderation
    public var moderationPayload: ModerationPayloadResponse?
    /// Suggested moderation action
    public var recommendedAction: String
    /// When the item was reviewed
    public var reviewedAt: Date?
    /// ID of the moderator who reviewed the item
    public var reviewedBy: String
    /// Severity level of the content
    public var severity: Int
    /// Current status of the review
    public var status: String
    /// Teams associated with this item
    public var teams: [String]?
    /// When the item was last updated
    public var updatedAt: Date

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

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case actions
        case activity
        case aiTextSeverity = "ai_text_severity"
        case assignedTo = "assigned_to"
        case bans
        case completedAt = "completed_at"
        case configKey = "config_key"
        case createdAt = "created_at"
        case entityCreator = "entity_creator"
        case entityCreatorId = "entity_creator_id"
        case entityId = "entity_id"
        case entityType = "entity_type"
        case feedsV2Activity = "feeds_v2_activity"
        case flags
        case flagsCount = "flags_count"
        case id
        case languages
        case moderationPayload = "moderation_payload"
        case recommendedAction = "recommended_action"
        case reviewedAt = "reviewed_at"
        case reviewedBy = "reviewed_by"
        case severity
        case status
        case teams
        case updatedAt = "updated_at"
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
