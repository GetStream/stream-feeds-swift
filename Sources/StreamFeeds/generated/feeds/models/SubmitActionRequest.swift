//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class SubmitActionRequest: @unchecked Sendable, Codable, JSONEncodable {
    public enum SubmitActionRequestActionType: String, Sendable, Codable, CaseIterable {
        case ban
        case block
        case bypass
        case custom
        case deEscalate = "de_escalate"
        case deleteActivity = "delete_activity"
        case deleteComment = "delete_comment"
        case deleteMessage = "delete_message"
        case deletePoll = "delete_poll"
        case deletePollAnswer = "delete_poll_answer"
        case deletePollOption = "delete_poll_option"
        case deleteReaction = "delete_reaction"
        case deleteUser = "delete_user"
        case deleteUserMessages = "delete_user_messages"
        case endCall = "end_call"
        case escalate
        case flag
        case kickUser = "kick_user"
        case markReviewed = "mark_reviewed"
        case rejectAppeal = "reject_appeal"
        case restore
        case shadowBlock = "shadow_block"
        case unban
        case unblock
        case unmask
        case unknown = "_unknown"

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let decodedValue = try? container.decode(String.self),
               let value = Self(rawValue: decodedValue) {
                self = value
            } else {
                self = .unknown
            }
        }
    }

    /// Type of moderation action to perform. One of: mark_reviewed, delete_message, delete_activity, delete_comment, delete_reaction, delete_poll, delete_poll_option, delete_poll_answer, ban, custom, unban, restore, delete_user, delete_user_messages, unblock, block, shadow_block, unmask, kick_user, end_call, escalate, de_escalate
    public var actionType: SubmitActionRequestActionType
    /// Configuration for custom moderation action
    public var custom: CustomActionRequestPayload?
    /// Configuration for activity deletion action
    public var deleteActivity: DeleteActivityRequestPayload?
    /// Configuration for reaction deletion action
    public var deleteReaction: DeleteReactionRequestPayload?
    /// UUID of the review queue item to act on
    public var itemId: String?
    /// Configuration for mark reviewed action
    public var markReviewed: MarkReviewedRequestPayload?

    public init(actionType: SubmitActionRequestActionType, custom: CustomActionRequestPayload? = nil, deleteActivity: DeleteActivityRequestPayload? = nil, deleteReaction: DeleteReactionRequestPayload? = nil, itemId: String? = nil, markReviewed: MarkReviewedRequestPayload? = nil) {
        self.actionType = actionType
        self.custom = custom
        self.deleteActivity = deleteActivity
        self.deleteReaction = deleteReaction
        self.itemId = itemId
        self.markReviewed = markReviewed
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case actionType = "action_type"
        case custom
        case deleteActivity = "delete_activity"
        case deleteReaction = "delete_reaction"
        case itemId = "item_id"
        case markReviewed = "mark_reviewed"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.actionType = try container.decode(SubmitActionRequestActionType.self, forKey: .actionType)
        self.custom = try container.decodeIfPresent(CustomActionRequestPayload.self, forKey: .custom)
        self.deleteActivity = try container.decodeIfPresent(DeleteActivityRequestPayload.self, forKey: .deleteActivity)
        self.deleteReaction = try container.decodeIfPresent(DeleteReactionRequestPayload.self, forKey: .deleteReaction)
        self.itemId = try container.decodeIfPresent(String.self, forKey: .itemId)
        self.markReviewed = try container.decodeIfPresent(MarkReviewedRequestPayload.self, forKey: .markReviewed)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
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
