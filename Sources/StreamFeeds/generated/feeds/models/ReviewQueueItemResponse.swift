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
    public var appeal: AppealItemResponse?
    /// User response object
    public var assignedTo: UserResponse?
    /// Associated ban records
    public var bans: [BanInfoResponse]
    /// When the review was completed
    public var completedAt: Date?
    /// Highest per-label confidence (0-1) any provider reported across the item's flags; absent when no flag carried one
    public var confidenceScore: Float?
    public var configKey: String?
    public var countryCode: String?
    /// When the item was created
    public var createdAt: Date
    public var entityCreator: EntityCreatorResponse?
    /// ID of who created the entity
    public var entityCreatorId: String?
    /// ID of the entity being reviewed
    public var entityId: String
    /// Type of entity being reviewed
    public var entityType: String
    /// Whether the item has been escalated
    public var escalated: Bool
    /// When the item was escalated
    public var escalatedAt: Date?
    /// ID of the moderator who escalated the item
    public var escalatedBy: String?
    public var escalationMetadata: EscalationMetadata?
    /// IDs of the item's flags a moderator marked as false positives
    public var falsePositiveFlags: [String]?
    public var feedsV2Activity: EnrichedActivity?
    public var feedsV2Reaction: Reaction?
    public var feedsV3Activity: ActivityResponse?
    public var feedsV3Comment: CommentResponse?
    /// Associated flag records
    public var flags: [ModerationFlagResponse]
    public var flagsCount: Int
    /// Unique identifier of the review queue item
    public var id: String
    /// Detected languages in the content
    public var languages: [String]
    public var latestModeratorAction: String
    /// Display policy for a review queue item's images and video
    public var mediaDisplay: MediaDisplayResponse
    /// Content payload for moderation
    public var moderationPayload: ModerationPayloadResponse?
    public var poll: PollResponseData?
    public var reaction: Reaction?
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

    public init(
        actions: [ActionLogResponse],
        activity: EnrichedActivity? = nil,
        aiTextSeverity: String,
        appeal: AppealItemResponse? = nil,
        assignedTo: UserResponse? = nil,
        bans: [BanInfoResponse],
        completedAt: Date? = nil,
        confidenceScore: Float? = nil,
        configKey: String? = nil,
        countryCode: String? = nil,
        createdAt: Date,
        entityCreator: EntityCreatorResponse? = nil,
        entityCreatorId: String? = nil,
        entityId: String,
        entityType: String,
        escalated: Bool,
        escalatedAt: Date? = nil,
        escalatedBy: String? = nil,
        escalationMetadata: EscalationMetadata? = nil,
        falsePositiveFlags: [String]? = nil,
        feedsV2Activity: EnrichedActivity? = nil,
        feedsV2Reaction: Reaction? = nil,
        feedsV3Activity: ActivityResponse? = nil,
        feedsV3Comment: CommentResponse? = nil,
        flags: [ModerationFlagResponse],
        flagsCount: Int,
        id: String,
        languages: [String],
        latestModeratorAction: String,
        mediaDisplay: MediaDisplayResponse,
        moderationPayload: ModerationPayloadResponse? = nil,
        poll: PollResponseData? = nil,
        reaction: Reaction? = nil,
        recommendedAction: String,
        reviewedAt: Date? = nil,
        reviewedBy: String,
        severity: Int,
        status: String,
        teams: [String]? = nil,
        updatedAt: Date
    ) {
        self.actions = actions
        self.activity = activity
        self.aiTextSeverity = aiTextSeverity
        self.appeal = appeal
        self.assignedTo = assignedTo
        self.bans = bans
        self.completedAt = completedAt
        self.confidenceScore = confidenceScore
        self.configKey = configKey
        self.countryCode = countryCode
        self.createdAt = createdAt
        self.entityCreator = entityCreator
        self.entityCreatorId = entityCreatorId
        self.entityId = entityId
        self.entityType = entityType
        self.escalated = escalated
        self.escalatedAt = escalatedAt
        self.escalatedBy = escalatedBy
        self.escalationMetadata = escalationMetadata
        self.falsePositiveFlags = falsePositiveFlags
        self.feedsV2Activity = feedsV2Activity
        self.feedsV2Reaction = feedsV2Reaction
        self.feedsV3Activity = feedsV3Activity
        self.feedsV3Comment = feedsV3Comment
        self.flags = flags
        self.flagsCount = flagsCount
        self.id = id
        self.languages = languages
        self.latestModeratorAction = latestModeratorAction
        self.mediaDisplay = mediaDisplay
        self.moderationPayload = moderationPayload
        self.poll = poll
        self.reaction = reaction
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
        case appeal
        case assignedTo = "assigned_to"
        case bans
        case completedAt = "completed_at"
        case confidenceScore = "confidence_score"
        case configKey = "config_key"
        case countryCode = "country_code"
        case createdAt = "created_at"
        case entityCreator = "entity_creator"
        case entityCreatorId = "entity_creator_id"
        case entityId = "entity_id"
        case entityType = "entity_type"
        case escalated
        case escalatedAt = "escalated_at"
        case escalatedBy = "escalated_by"
        case escalationMetadata = "escalation_metadata"
        case falsePositiveFlags = "false_positive_flags"
        case feedsV2Activity = "feeds_v2_activity"
        case feedsV2Reaction = "feeds_v2_reaction"
        case feedsV3Activity = "feeds_v3_activity"
        case feedsV3Comment = "feeds_v3_comment"
        case flags
        case flagsCount = "flags_count"
        case id
        case languages
        case latestModeratorAction = "latest_moderator_action"
        case mediaDisplay = "media_display"
        case moderationPayload = "moderation_payload"
        case poll
        case reaction
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
            lhs.appeal == rhs.appeal &&
            lhs.assignedTo == rhs.assignedTo &&
            lhs.bans == rhs.bans &&
            lhs.completedAt == rhs.completedAt &&
            lhs.confidenceScore == rhs.confidenceScore &&
            lhs.configKey == rhs.configKey &&
            lhs.countryCode == rhs.countryCode &&
            lhs.createdAt == rhs.createdAt &&
            lhs.entityCreator == rhs.entityCreator &&
            lhs.entityCreatorId == rhs.entityCreatorId &&
            lhs.entityId == rhs.entityId &&
            lhs.entityType == rhs.entityType &&
            lhs.escalated == rhs.escalated &&
            lhs.escalatedAt == rhs.escalatedAt &&
            lhs.escalatedBy == rhs.escalatedBy &&
            lhs.escalationMetadata == rhs.escalationMetadata &&
            lhs.falsePositiveFlags == rhs.falsePositiveFlags &&
            lhs.feedsV2Activity == rhs.feedsV2Activity &&
            lhs.feedsV2Reaction == rhs.feedsV2Reaction &&
            lhs.feedsV3Activity == rhs.feedsV3Activity &&
            lhs.feedsV3Comment == rhs.feedsV3Comment &&
            lhs.flags == rhs.flags &&
            lhs.flagsCount == rhs.flagsCount &&
            lhs.id == rhs.id &&
            lhs.languages == rhs.languages &&
            lhs.latestModeratorAction == rhs.latestModeratorAction &&
            lhs.mediaDisplay == rhs.mediaDisplay &&
            lhs.moderationPayload == rhs.moderationPayload &&
            lhs.poll == rhs.poll &&
            lhs.reaction == rhs.reaction &&
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
        hasher.combine(appeal)
        hasher.combine(assignedTo)
        hasher.combine(bans)
        hasher.combine(completedAt)
        hasher.combine(confidenceScore)
        hasher.combine(configKey)
        hasher.combine(countryCode)
        hasher.combine(createdAt)
        hasher.combine(entityCreator)
        hasher.combine(entityCreatorId)
        hasher.combine(entityId)
        hasher.combine(entityType)
        hasher.combine(escalated)
        hasher.combine(escalatedAt)
        hasher.combine(escalatedBy)
        hasher.combine(escalationMetadata)
        hasher.combine(falsePositiveFlags)
        hasher.combine(feedsV2Activity)
        hasher.combine(feedsV2Reaction)
        hasher.combine(feedsV3Activity)
        hasher.combine(feedsV3Comment)
        hasher.combine(flags)
        hasher.combine(flagsCount)
        hasher.combine(id)
        hasher.combine(languages)
        hasher.combine(latestModeratorAction)
        hasher.combine(mediaDisplay)
        hasher.combine(moderationPayload)
        hasher.combine(poll)
        hasher.combine(reaction)
        hasher.combine(recommendedAction)
        hasher.combine(reviewedAt)
        hasher.combine(reviewedBy)
        hasher.combine(severity)
        hasher.combine(status)
        hasher.combine(teams)
        hasher.combine(updatedAt)
    }
}
