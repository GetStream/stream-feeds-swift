//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class ReviewQueueItem: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var actions: [ActionLog]
    public var activity: EnrichedActivity?
    public var aiTextSeverity: String
    public var assignedTo: User?
    public var bans: [Ban]
    public var bounceCount: Int
    public var configKey: String
    public var contentChanged: Bool
    public var createdAt: Date
    public var entityCreator: EntityCreator?
    public var entityId: String
    public var entityType: String
    public var feedsV2Activity: EnrichedActivity?
    public var flags: [Flag]
    public var flagsCount: Int
    public var hasImage: Bool
    public var hasText: Bool
    public var hasVideo: Bool
    public var id: String
    public var languages: [String]
    public var moderationPayload: ModerationPayload?
    public var moderationPayloadHash: String
    public var recommendedAction: String
    public var reviewedBy: String
    public var severity: Int
    public var status: String
    public var teams: [String]
    public var updatedAt: Date

    public init(actions: [ActionLog], activity: EnrichedActivity? = nil, aiTextSeverity: String, assignedTo: User? = nil, bans: [Ban], bounceCount: Int, configKey: String, contentChanged: Bool, createdAt: Date, entityCreator: EntityCreator? = nil, entityId: String, entityType: String, feedsV2Activity: EnrichedActivity? = nil, flags: [Flag], flagsCount: Int, hasImage: Bool, hasText: Bool, hasVideo: Bool, id: String, languages: [String], moderationPayload: ModerationPayload? = nil, moderationPayloadHash: String, recommendedAction: String, reviewedBy: String, severity: Int, status: String, teams: [String], updatedAt: Date) {
        self.actions = actions
        self.activity = activity
        self.aiTextSeverity = aiTextSeverity
        self.assignedTo = assignedTo
        self.bans = bans
        self.bounceCount = bounceCount
        self.configKey = configKey
        self.contentChanged = contentChanged
        self.createdAt = createdAt
        self.entityCreator = entityCreator
        self.entityId = entityId
        self.entityType = entityType
        self.feedsV2Activity = feedsV2Activity
        self.flags = flags
        self.flagsCount = flagsCount
        self.hasImage = hasImage
        self.hasText = hasText
        self.hasVideo = hasVideo
        self.id = id
        self.languages = languages
        self.moderationPayload = moderationPayload
        self.moderationPayloadHash = moderationPayloadHash
        self.recommendedAction = recommendedAction
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
        case bounceCount = "bounce_count"
        case configKey = "config_key"
        case contentChanged = "content_changed"
        case createdAt = "created_at"
        case entityCreator = "entity_creator"
        case entityId = "entity_id"
        case entityType = "entity_type"
        case feedsV2Activity = "feeds_v2_activity"
        case flags
        case flagsCount = "flags_count"
        case hasImage = "has_image"
        case hasText = "has_text"
        case hasVideo = "has_video"
        case id
        case languages
        case moderationPayload = "moderation_payload"
        case moderationPayloadHash = "moderation_payload_hash"
        case recommendedAction = "recommended_action"
        case reviewedBy = "reviewed_by"
        case severity
        case status
        case teams
        case updatedAt = "updated_at"
    }

    public static func == (lhs: ReviewQueueItem, rhs: ReviewQueueItem) -> Bool {
        lhs.actions == rhs.actions &&
            lhs.activity == rhs.activity &&
            lhs.aiTextSeverity == rhs.aiTextSeverity &&
            lhs.assignedTo == rhs.assignedTo &&
            lhs.bans == rhs.bans &&
            lhs.bounceCount == rhs.bounceCount &&
            lhs.configKey == rhs.configKey &&
            lhs.contentChanged == rhs.contentChanged &&
            lhs.createdAt == rhs.createdAt &&
            lhs.entityCreator == rhs.entityCreator &&
            lhs.entityId == rhs.entityId &&
            lhs.entityType == rhs.entityType &&
            lhs.feedsV2Activity == rhs.feedsV2Activity &&
            lhs.flags == rhs.flags &&
            lhs.flagsCount == rhs.flagsCount &&
            lhs.hasImage == rhs.hasImage &&
            lhs.hasText == rhs.hasText &&
            lhs.hasVideo == rhs.hasVideo &&
            lhs.id == rhs.id &&
            lhs.languages == rhs.languages &&
            lhs.moderationPayload == rhs.moderationPayload &&
            lhs.moderationPayloadHash == rhs.moderationPayloadHash &&
            lhs.recommendedAction == rhs.recommendedAction &&
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
        hasher.combine(bounceCount)
        hasher.combine(configKey)
        hasher.combine(contentChanged)
        hasher.combine(createdAt)
        hasher.combine(entityCreator)
        hasher.combine(entityId)
        hasher.combine(entityType)
        hasher.combine(feedsV2Activity)
        hasher.combine(flags)
        hasher.combine(flagsCount)
        hasher.combine(hasImage)
        hasher.combine(hasText)
        hasher.combine(hasVideo)
        hasher.combine(id)
        hasher.combine(languages)
        hasher.combine(moderationPayload)
        hasher.combine(moderationPayloadHash)
        hasher.combine(recommendedAction)
        hasher.combine(reviewedBy)
        hasher.combine(severity)
        hasher.combine(status)
        hasher.combine(teams)
        hasher.combine(updatedAt)
    }
}
