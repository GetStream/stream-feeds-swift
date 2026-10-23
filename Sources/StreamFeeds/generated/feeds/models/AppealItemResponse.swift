//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class AppealItemResponse: @unchecked Sendable, Codable, JSONEncodable {
    /// Full chronological history of all moderation actions on the review queue item
    public var actions: [ActionLogResponse]?
    /// Text severity level assigned by the AI provider
    public var aiTextSeverity: String?
    /// Reason Text of the Appeal Item
    public var appealReason: String
    /// Detected language of the appeal_reason text itself
    public var appealReasonLanguage: String?
    /// Attachments(e.g. Images) of the Appeal Item
    public var attachments: [String]?
    /// Moderation policy key that was applied
    public var configKey: String?
    /// When the flag was created
    public var createdAt: Date
    /// Decision Reason of the Appeal Item
    public var decisionReason: String?
    public var entityContent: ModerationPayload?
    /// ID of the entity
    public var entityId: String
    /// Type of entity
    public var entityType: String
    /// Classification labels from automated and manual review
    public var flagLabels: [String]?
    /// Types of flags applied to the entity (e.g. user_report, bodyguard)
    public var flagTypes: [String]?
    /// Per-provider flag records explaining why the action was taken
    public var flags: [ModerationFlagResponse]?
    public var id: String
    /// Detected languages in the content
    public var languages: [String]?
    public var moderationAction: ActionLogResponse?
    public var originalModerationAction: ActionLogResponse?
    /// Action recommended by the automated moderation system (e.g. flag, remove, shadow)
    public var recommendedAction: String?
    /// ID of the review queue item linked to this appeal, if the appeal was submitted with one
    public var reviewQueueItemId: String?
    /// Overall content severity score (1–100)
    public var severity: Int?
    /// Status of the Appeal Item
    public var status: String
    /// When the flag was last updated
    public var updatedAt: Date
    /// User response object
    public var user: UserResponse?

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

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case actions
        case aiTextSeverity = "ai_text_severity"
        case appealReason = "appeal_reason"
        case appealReasonLanguage = "appeal_reason_language"
        case attachments
        case configKey = "config_key"
        case createdAt = "created_at"
        case decisionReason = "decision_reason"
        case entityContent = "entity_content"
        case entityId = "entity_id"
        case entityType = "entity_type"
        case flagLabels = "flag_labels"
        case flagTypes = "flag_types"
        case flags
        case id
        case languages
        case moderationAction = "moderation_action"
        case originalModerationAction = "original_moderation_action"
        case recommendedAction = "recommended_action"
        case reviewQueueItemId = "review_queue_item_id"
        case severity
        case status
        case updatedAt = "updated_at"
        case user
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
