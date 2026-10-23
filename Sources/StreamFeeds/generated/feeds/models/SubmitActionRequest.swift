//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class SubmitActionRequestActionType: RawRepresentable, Codable, Hashable, Sendable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public static let ban = SubmitActionRequestActionType(rawValue: "ban")
    public static let block = SubmitActionRequestActionType(rawValue: "block")
    public static let bypass = SubmitActionRequestActionType(rawValue: "bypass")
    public static let custom = SubmitActionRequestActionType(rawValue: "custom")
    public static let deEscalate = SubmitActionRequestActionType(rawValue: "de_escalate")
    public static let deleteActivity = SubmitActionRequestActionType(rawValue: "delete_activity")
    public static let deleteComment = SubmitActionRequestActionType(rawValue: "delete_comment")
    public static let deleteMessage = SubmitActionRequestActionType(rawValue: "delete_message")
    public static let deletePoll = SubmitActionRequestActionType(rawValue: "delete_poll")
    public static let deletePollAnswer = SubmitActionRequestActionType(rawValue: "delete_poll_answer")
    public static let deletePollOption = SubmitActionRequestActionType(rawValue: "delete_poll_option")
    public static let deleteReaction = SubmitActionRequestActionType(rawValue: "delete_reaction")
    public static let deleteUser = SubmitActionRequestActionType(rawValue: "delete_user")
    public static let deleteUserMessages = SubmitActionRequestActionType(rawValue: "delete_user_messages")
    public static let endCall = SubmitActionRequestActionType(rawValue: "end_call")
    public static let escalate = SubmitActionRequestActionType(rawValue: "escalate")
    public static let flag = SubmitActionRequestActionType(rawValue: "flag")
    public static let kickUser = SubmitActionRequestActionType(rawValue: "kick_user")
    public static let markReviewed = SubmitActionRequestActionType(rawValue: "mark_reviewed")
    public static let rejectAppeal = SubmitActionRequestActionType(rawValue: "reject_appeal")
    public static let restore = SubmitActionRequestActionType(rawValue: "restore")
    public static let shadowBlock = SubmitActionRequestActionType(rawValue: "shadow_block")
    public static let unban = SubmitActionRequestActionType(rawValue: "unban")
    public static let unblock = SubmitActionRequestActionType(rawValue: "unblock")
    public static let unmask = SubmitActionRequestActionType(rawValue: "unmask")
}

public final class SubmitActionRequest: Sendable, Codable, JSONEncodable {
    /// Type of moderation action to perform. One of: mark_reviewed, delete_message, delete_activity, delete_comment, delete_reaction, delete_poll, delete_poll_option, delete_poll_answer, ban, custom, unban, restore, delete_user, delete_user_messages, unblock, block, shadow_block, unmask, kick_user, end_call, escalate, de_escalate
    public let actionType: SubmitActionRequestActionType
    /// Configuration for custom moderation action
    public let custom: CustomActionRequestPayload?
    /// Configuration for activity deletion action
    public let deleteActivity: DeleteActivityRequestPayload?
    /// Configuration for reaction deletion action
    public let deleteReaction: DeleteReactionRequestPayload?
    /// UUID of the review queue item to act on
    public let itemId: String?
    /// Configuration for mark reviewed action
    public let markReviewed: MarkReviewedRequestPayload?

    public init(actionType: SubmitActionRequestActionType, custom: CustomActionRequestPayload? = nil, deleteActivity: DeleteActivityRequestPayload? = nil, deleteReaction: DeleteReactionRequestPayload? = nil, itemId: String? = nil, markReviewed: MarkReviewedRequestPayload? = nil) {
        self.actionType = actionType
        self.custom = custom
        self.deleteActivity = deleteActivity
        self.deleteReaction = deleteReaction
        self.itemId = itemId
        self.markReviewed = markReviewed
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.actionType = try container.decode(SubmitActionRequestActionType.self, forKey: .actionType)
        self.custom = try container.decodeIfPresent(CustomActionRequestPayload.self, forKey: .custom)
        self.deleteActivity = try container.decodeIfPresent(DeleteActivityRequestPayload.self, forKey: .deleteActivity)
        self.deleteReaction = try container.decodeIfPresent(DeleteReactionRequestPayload.self, forKey: .deleteReaction)
        self.itemId = try container.decodeIfPresent(String.self, forKey: .itemId)
        self.markReviewed = try container.decodeIfPresent(MarkReviewedRequestPayload.self, forKey: .markReviewed)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(actionType, forKey: .actionType)
        try container.encodeIfPresent(custom, forKey: .custom)
        try container.encodeIfPresent(deleteActivity, forKey: .deleteActivity)
        try container.encodeIfPresent(deleteReaction, forKey: .deleteReaction)
        try container.encodeIfPresent(itemId, forKey: .itemId)
        try container.encodeIfPresent(markReviewed, forKey: .markReviewed)
    }
}

extension SubmitActionRequest: Hashable {
    public static func == (lhs: SubmitActionRequest, rhs: SubmitActionRequest) -> Bool {
        lhs.actionType == rhs.actionType &&
            lhs.custom == rhs.custom &&
            lhs.deleteActivity == rhs.deleteActivity &&
            lhs.deleteReaction == rhs.deleteReaction &&
            lhs.itemId == rhs.itemId &&
            lhs.markReviewed == rhs.markReviewed
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(actionType)
        hasher.combine(custom)
        hasher.combine(deleteActivity)
        hasher.combine(deleteReaction)
        hasher.combine(itemId)
        hasher.combine(markReviewed)
    }
}
