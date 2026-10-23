//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class ReviewQueueItemResponse: Sendable, Codable, JSONEncodable {
    /// Moderation actions taken
    public let actions: [ActionLogResponse]
    public let activity: EnrichedActivity?
    /// AI-determined text severity
    public let aiTextSeverity: String
    public let appeal: AppealItemResponse?
    /// User response object
    public let assignedTo: UserResponse?
    /// Associated ban records
    public let bans: [BanInfoResponse]
    /// When the review was completed
    public let completedAt: Date?
    /// Highest per-label confidence (0-1) any provider reported across the item's flags; absent when no flag carried one
    public let confidenceScore: Double?
    public let configKey: String?
    public let countryCode: String?
    /// When the item was created
    public let createdAt: Date
    public let entityCreator: EntityCreatorResponse?
    /// ID of who created the entity
    public let entityCreatorId: String?
    /// ID of the entity being reviewed
    public let entityId: String
    /// Type of entity being reviewed
    public let entityType: String
    /// Whether the item has been escalated
    public let escalated: Bool
    /// When the item was escalated
    public let escalatedAt: Date?
    /// ID of the moderator who escalated the item
    public let escalatedBy: String?
    public let escalationMetadata: EscalationMetadata?
    /// IDs of the item's flags a moderator marked as false positives
    public let falsePositiveFlags: [String]?
    public let feedsV2Activity: EnrichedActivity?
    public let feedsV2Reaction: Reaction?
    public let feedsV3Activity: ActivityResponse?
    public let feedsV3Comment: CommentResponse?
    /// Associated flag records
    public let flags: [ModerationFlagResponse]
    public let flagsCount: Int
    /// Unique identifier of the review queue item
    public let id: String
    /// Detected languages in the content
    public let languages: [String]
    public let latestModeratorAction: String
    /// Display policy for a review queue item's images and video
    public let mediaDisplay: MediaDisplayResponse
    /// Content payload for moderation
    public let moderationPayload: ModerationPayloadResponse?
    public let poll: PollResponseData?
    public let reaction: Reaction?
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

    public init(actions: [ActionLogResponse], activity: EnrichedActivity? = nil, aiTextSeverity: String, appeal: AppealItemResponse? = nil, assignedTo: UserResponse? = nil, bans: [BanInfoResponse], completedAt: Date? = nil, confidenceScore: Double? = nil, configKey: String? = nil, countryCode: String? = nil, createdAt: Date, entityCreator: EntityCreatorResponse? = nil, entityCreatorId: String? = nil, entityId: String, entityType: String, escalated: Bool, escalatedAt: Date? = nil, escalatedBy: String? = nil, escalationMetadata: EscalationMetadata? = nil, falsePositiveFlags: [String]? = nil, feedsV2Activity: EnrichedActivity? = nil, feedsV2Reaction: Reaction? = nil, feedsV3Activity: ActivityResponse? = nil, feedsV3Comment: CommentResponse? = nil, flags: [ModerationFlagResponse], flagsCount: Int, id: String, languages: [String], latestModeratorAction: String, mediaDisplay: MediaDisplayResponse, moderationPayload: ModerationPayloadResponse? = nil, poll: PollResponseData? = nil, reaction: Reaction? = nil, recommendedAction: String, reviewedAt: Date? = nil, reviewedBy: String, severity: Int, status: String, teams: [String]? = nil, updatedAt: Date) {
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

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.actions = try container.decode([ActionLogResponse].self, forKey: .actions)
        self.activity = try container.decodeIfPresent(EnrichedActivity.self, forKey: .activity)
        self.aiTextSeverity = try container.decode(String.self, forKey: .aiTextSeverity)
        self.appeal = try container.decodeIfPresent(AppealItemResponse.self, forKey: .appeal)
        self.assignedTo = try container.decodeIfPresent(UserResponse.self, forKey: .assignedTo)
        self.bans = try container.decode([BanInfoResponse].self, forKey: .bans)
        self.completedAt = try container.decodeIfPresent(Date.self, forKey: .completedAt)
        self.confidenceScore = try container.decodeIfPresent(Double.self, forKey: .confidenceScore)
        self.configKey = try container.decodeIfPresent(String.self, forKey: .configKey)
        self.countryCode = try container.decodeIfPresent(String.self, forKey: .countryCode)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.entityCreator = try container.decodeIfPresent(EntityCreatorResponse.self, forKey: .entityCreator)
        self.entityCreatorId = try container.decodeIfPresent(String.self, forKey: .entityCreatorId)
        self.entityId = try container.decode(String.self, forKey: .entityId)
        self.entityType = try container.decode(String.self, forKey: .entityType)
        self.escalated = try container.decode(Bool.self, forKey: .escalated)
        self.escalatedAt = try container.decodeIfPresent(Date.self, forKey: .escalatedAt)
        self.escalatedBy = try container.decodeIfPresent(String.self, forKey: .escalatedBy)
        self.escalationMetadata = try container.decodeIfPresent(EscalationMetadata.self, forKey: .escalationMetadata)
        self.falsePositiveFlags = try container.decodeIfPresent([String].self, forKey: .falsePositiveFlags)
        self.feedsV2Activity = try container.decodeIfPresent(EnrichedActivity.self, forKey: .feedsV2Activity)
        self.feedsV2Reaction = try container.decodeIfPresent(Reaction.self, forKey: .feedsV2Reaction)
        self.feedsV3Activity = try container.decodeIfPresent(ActivityResponse.self, forKey: .feedsV3Activity)
        self.feedsV3Comment = try container.decodeIfPresent(CommentResponse.self, forKey: .feedsV3Comment)
        self.flags = try container.decode([ModerationFlagResponse].self, forKey: .flags)
        self.flagsCount = try container.decode(Int.self, forKey: .flagsCount)
        self.id = try container.decode(String.self, forKey: .id)
        self.languages = try container.decode([String].self, forKey: .languages)
        self.latestModeratorAction = try container.decode(String.self, forKey: .latestModeratorAction)
        self.mediaDisplay = try container.decode(MediaDisplayResponse.self, forKey: .mediaDisplay)
        self.moderationPayload = try container.decodeIfPresent(ModerationPayloadResponse.self, forKey: .moderationPayload)
        self.poll = try container.decodeIfPresent(PollResponseData.self, forKey: .poll)
        self.reaction = try container.decodeIfPresent(Reaction.self, forKey: .reaction)
        self.recommendedAction = try container.decode(String.self, forKey: .recommendedAction)
        self.reviewedAt = try container.decodeIfPresent(Date.self, forKey: .reviewedAt)
        self.reviewedBy = try container.decode(String.self, forKey: .reviewedBy)
        self.severity = try container.decode(Int.self, forKey: .severity)
        self.status = try container.decode(String.self, forKey: .status)
        self.teams = try container.decodeIfPresent([String].self, forKey: .teams)
        self.updatedAt = try container.decode(Date.self, forKey: .updatedAt)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(actions, forKey: .actions)
        try container.encodeIfPresent(activity, forKey: .activity)
        try container.encode(aiTextSeverity, forKey: .aiTextSeverity)
        try container.encodeIfPresent(appeal, forKey: .appeal)
        try container.encodeIfPresent(assignedTo, forKey: .assignedTo)
        try container.encode(bans, forKey: .bans)
        try container.encodeIfPresent(completedAt, forKey: .completedAt)
        try container.encodeIfPresent(confidenceScore, forKey: .confidenceScore)
        try container.encodeIfPresent(configKey, forKey: .configKey)
        try container.encodeIfPresent(countryCode, forKey: .countryCode)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encodeIfPresent(entityCreator, forKey: .entityCreator)
        try container.encodeIfPresent(entityCreatorId, forKey: .entityCreatorId)
        try container.encode(entityId, forKey: .entityId)
        try container.encode(entityType, forKey: .entityType)
        try container.encode(escalated, forKey: .escalated)
        try container.encodeIfPresent(escalatedAt, forKey: .escalatedAt)
        try container.encodeIfPresent(escalatedBy, forKey: .escalatedBy)
        try container.encodeIfPresent(escalationMetadata, forKey: .escalationMetadata)
        try container.encodeIfPresent(falsePositiveFlags, forKey: .falsePositiveFlags)
        try container.encodeIfPresent(feedsV2Activity, forKey: .feedsV2Activity)
        try container.encodeIfPresent(feedsV2Reaction, forKey: .feedsV2Reaction)
        try container.encodeIfPresent(feedsV3Activity, forKey: .feedsV3Activity)
        try container.encodeIfPresent(feedsV3Comment, forKey: .feedsV3Comment)
        try container.encode(flags, forKey: .flags)
        try container.encode(flagsCount, forKey: .flagsCount)
        try container.encode(id, forKey: .id)
        try container.encode(languages, forKey: .languages)
        try container.encode(latestModeratorAction, forKey: .latestModeratorAction)
        try container.encode(mediaDisplay, forKey: .mediaDisplay)
        try container.encodeIfPresent(moderationPayload, forKey: .moderationPayload)
        try container.encodeIfPresent(poll, forKey: .poll)
        try container.encodeIfPresent(reaction, forKey: .reaction)
        try container.encode(recommendedAction, forKey: .recommendedAction)
        try container.encodeIfPresent(reviewedAt, forKey: .reviewedAt)
        try container.encode(reviewedBy, forKey: .reviewedBy)
        try container.encode(severity, forKey: .severity)
        try container.encode(status, forKey: .status)
        try container.encodeIfPresent(teams, forKey: .teams)
        try container.encode(updatedAt, forKey: .updatedAt)
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
