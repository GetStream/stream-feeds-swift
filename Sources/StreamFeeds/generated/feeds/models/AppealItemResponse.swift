//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class AppealItemResponse: Sendable, Codable, JSONEncodable {
    /// Full chronological history of all moderation actions on the review queue item
    public let actions: [ActionLogResponse]?
    /// Text severity level assigned by the AI provider
    public let aiTextSeverity: String?
    /// Reason Text of the Appeal Item
    public let appealReason: String
    /// Detected language of the appeal_reason text itself
    public let appealReasonLanguage: String?
    /// Attachments(e.g. Images) of the Appeal Item
    public let attachments: [String]?
    /// Moderation policy key that was applied
    public let configKey: String?
    /// When the flag was created
    public let createdAt: Date
    /// Decision Reason of the Appeal Item
    public let decisionReason: String?
    public let entityContent: ModerationPayload?
    /// ID of the entity
    public let entityId: String
    /// Type of entity
    public let entityType: String
    /// Classification labels from automated and manual review
    public let flagLabels: [String]?
    /// Types of flags applied to the entity (e.g. user_report, bodyguard)
    public let flagTypes: [String]?
    /// Per-provider flag records explaining why the action was taken
    public let flags: [ModerationFlagResponse]?
    public let id: String
    /// Detected languages in the content
    public let languages: [String]?
    public let moderationAction: ActionLogResponse?
    public let originalModerationAction: ActionLogResponse?
    /// Action recommended by the automated moderation system (e.g. flag, remove, shadow)
    public let recommendedAction: String?
    /// ID of the review queue item linked to this appeal, if the appeal was submitted with one
    public let reviewQueueItemId: String?
    /// Overall content severity score (1–100)
    public let severity: Int?
    /// Status of the Appeal Item
    public let status: String
    /// When the flag was last updated
    public let updatedAt: Date
    /// User response object
    public let user: UserResponse?

    public init(actions: [ActionLogResponse]? = nil, aiTextSeverity: String? = nil, appealReason: String, appealReasonLanguage: String? = nil, attachments: [String]? = nil, configKey: String? = nil, createdAt: Date, decisionReason: String? = nil, entityContent: ModerationPayload? = nil, entityId: String, entityType: String, flagLabels: [String]? = nil, flagTypes: [String]? = nil, flags: [ModerationFlagResponse]? = nil, id: String, languages: [String]? = nil, moderationAction: ActionLogResponse? = nil, originalModerationAction: ActionLogResponse? = nil, recommendedAction: String? = nil, reviewQueueItemId: String? = nil, severity: Int? = nil, status: String, updatedAt: Date, user: UserResponse? = nil) {
        self.actions = actions
        self.aiTextSeverity = aiTextSeverity
        self.appealReason = appealReason
        self.appealReasonLanguage = appealReasonLanguage
        self.attachments = attachments
        self.configKey = configKey
        self.createdAt = createdAt
        self.decisionReason = decisionReason
        self.entityContent = entityContent
        self.entityId = entityId
        self.entityType = entityType
        self.flagLabels = flagLabels
        self.flagTypes = flagTypes
        self.flags = flags
        self.id = id
        self.languages = languages
        self.moderationAction = moderationAction
        self.originalModerationAction = originalModerationAction
        self.recommendedAction = recommendedAction
        self.reviewQueueItemId = reviewQueueItemId
        self.severity = severity
        self.status = status
        self.updatedAt = updatedAt
        self.user = user
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.actions = try container.decodeIfPresent([ActionLogResponse].self, forKey: .actions)
        self.aiTextSeverity = try container.decodeIfPresent(String.self, forKey: .aiTextSeverity)
        self.appealReason = try container.decode(String.self, forKey: .appealReason)
        self.appealReasonLanguage = try container.decodeIfPresent(String.self, forKey: .appealReasonLanguage)
        self.attachments = try container.decodeIfPresent([String].self, forKey: .attachments)
        self.configKey = try container.decodeIfPresent(String.self, forKey: .configKey)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.decisionReason = try container.decodeIfPresent(String.self, forKey: .decisionReason)
        self.entityContent = try container.decodeIfPresent(ModerationPayload.self, forKey: .entityContent)
        self.entityId = try container.decode(String.self, forKey: .entityId)
        self.entityType = try container.decode(String.self, forKey: .entityType)
        self.flagLabels = try container.decodeIfPresent([String].self, forKey: .flagLabels)
        self.flagTypes = try container.decodeIfPresent([String].self, forKey: .flagTypes)
        self.flags = try container.decodeIfPresent([ModerationFlagResponse].self, forKey: .flags)
        self.id = try container.decode(String.self, forKey: .id)
        self.languages = try container.decodeIfPresent([String].self, forKey: .languages)
        self.moderationAction = try container.decodeIfPresent(ActionLogResponse.self, forKey: .moderationAction)
        self.originalModerationAction = try container.decodeIfPresent(ActionLogResponse.self, forKey: .originalModerationAction)
        self.recommendedAction = try container.decodeIfPresent(String.self, forKey: .recommendedAction)
        self.reviewQueueItemId = try container.decodeIfPresent(String.self, forKey: .reviewQueueItemId)
        self.severity = try container.decodeIfPresent(Int.self, forKey: .severity)
        self.status = try container.decode(String.self, forKey: .status)
        self.updatedAt = try container.decode(Date.self, forKey: .updatedAt)
        self.user = try container.decodeIfPresent(UserResponse.self, forKey: .user)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(actions, forKey: .actions)
        try container.encodeIfPresent(aiTextSeverity, forKey: .aiTextSeverity)
        try container.encode(appealReason, forKey: .appealReason)
        try container.encodeIfPresent(appealReasonLanguage, forKey: .appealReasonLanguage)
        try container.encodeIfPresent(attachments, forKey: .attachments)
        try container.encodeIfPresent(configKey, forKey: .configKey)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encodeIfPresent(decisionReason, forKey: .decisionReason)
        try container.encodeIfPresent(entityContent, forKey: .entityContent)
        try container.encode(entityId, forKey: .entityId)
        try container.encode(entityType, forKey: .entityType)
        try container.encodeIfPresent(flagLabels, forKey: .flagLabels)
        try container.encodeIfPresent(flagTypes, forKey: .flagTypes)
        try container.encodeIfPresent(flags, forKey: .flags)
        try container.encode(id, forKey: .id)
        try container.encodeIfPresent(languages, forKey: .languages)
        try container.encodeIfPresent(moderationAction, forKey: .moderationAction)
        try container.encodeIfPresent(originalModerationAction, forKey: .originalModerationAction)
        try container.encodeIfPresent(recommendedAction, forKey: .recommendedAction)
        try container.encodeIfPresent(reviewQueueItemId, forKey: .reviewQueueItemId)
        try container.encodeIfPresent(severity, forKey: .severity)
        try container.encode(status, forKey: .status)
        try container.encode(updatedAt, forKey: .updatedAt)
        try container.encodeIfPresent(user, forKey: .user)
    }
}

extension AppealItemResponse: Hashable {
    public static func == (lhs: AppealItemResponse, rhs: AppealItemResponse) -> Bool {
        lhs.actions == rhs.actions &&
            lhs.aiTextSeverity == rhs.aiTextSeverity &&
            lhs.appealReason == rhs.appealReason &&
            lhs.appealReasonLanguage == rhs.appealReasonLanguage &&
            lhs.attachments == rhs.attachments &&
            lhs.configKey == rhs.configKey &&
            lhs.createdAt == rhs.createdAt &&
            lhs.decisionReason == rhs.decisionReason &&
            lhs.entityContent == rhs.entityContent &&
            lhs.entityId == rhs.entityId &&
            lhs.entityType == rhs.entityType &&
            lhs.flagLabels == rhs.flagLabels &&
            lhs.flagTypes == rhs.flagTypes &&
            lhs.flags == rhs.flags &&
            lhs.id == rhs.id &&
            lhs.languages == rhs.languages &&
            lhs.moderationAction == rhs.moderationAction &&
            lhs.originalModerationAction == rhs.originalModerationAction &&
            lhs.recommendedAction == rhs.recommendedAction &&
            lhs.reviewQueueItemId == rhs.reviewQueueItemId &&
            lhs.severity == rhs.severity &&
            lhs.status == rhs.status &&
            lhs.updatedAt == rhs.updatedAt &&
            lhs.user == rhs.user
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(actions)
        hasher.combine(aiTextSeverity)
        hasher.combine(appealReason)
        hasher.combine(appealReasonLanguage)
        hasher.combine(attachments)
        hasher.combine(configKey)
        hasher.combine(createdAt)
        hasher.combine(decisionReason)
        hasher.combine(entityContent)
        hasher.combine(entityId)
        hasher.combine(entityType)
        hasher.combine(flagLabels)
        hasher.combine(flagTypes)
        hasher.combine(flags)
        hasher.combine(id)
        hasher.combine(languages)
        hasher.combine(moderationAction)
        hasher.combine(originalModerationAction)
        hasher.combine(recommendedAction)
        hasher.combine(reviewQueueItemId)
        hasher.combine(severity)
        hasher.combine(status)
        hasher.combine(updatedAt)
        hasher.combine(user)
    }
}
