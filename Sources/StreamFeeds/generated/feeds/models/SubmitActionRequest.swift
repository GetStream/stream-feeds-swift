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
    /// UUID of the appeal to act on (required for reject_appeal, optional for other actions)
    public var appealId: String?
    /// Configuration for block action
    public var block: BlockActionRequestPayload?
    public var bypass: BypassActionRequest?
    /// Configuration for custom moderation action
    public var custom: CustomActionRequestPayload?
    /// Configuration for activity deletion action
    public var deleteActivity: DeleteActivityRequestPayload?
    /// Configuration for comment deletion action
    public var deleteComment: DeleteCommentRequestPayload?
    /// Configuration for poll deletion action. Poll deletion is always permanent.
    public var deletePoll: DeletePollRequestPayload?
    /// Configuration for deleting the free-text poll answer a review item was raised for. Chat polls only. Deletion is permanent; the poll and other votes are kept.
    public var deletePollAnswer: DeletePollAnswerRequestPayload?
    /// Configuration for deleting the single poll option a review item was raised for. Deletion is permanent; the rest of the poll is kept.
    public var deletePollOption: DeletePollOptionRequestPayload?
    /// Configuration for reaction deletion action
    public var deleteReaction: DeleteReactionRequestPayload?
    /// Configuration for escalation action
    public var escalate: EscalatePayload?
    public var flag: FlagRequest?
    /// UUID of the review queue item to act on
    public var itemId: String?
    /// Configuration for mark reviewed action
    public var markReviewed: MarkReviewedRequestPayload?
    /// Configuration for rejecting an appeal
    public var rejectAppeal: RejectAppealRequestPayload?
    /// Configuration for restore action. State-aware: reverses whichever of a delete, a block, or a shadow block currently applies to the content (including both a delete and a block/shadow block at once).
    public var restore: RestoreActionRequestPayload?
    /// Configuration for shadow block action
    public var shadowBlock: ShadowBlockActionRequestPayload?
    /// Deprecated: Use restore instead, which now also reverses a block or shadow block. Configuration for unblock action.
    @available(*, deprecated, message: "Use restore instead, which now also reverses a block or shadow block.")
    public var unblock: UnblockActionRequestPayload? { get { _unblock } set { _unblock = newValue } }
    private var _unblock: UnblockActionRequestPayload?

    public init(actionType: SubmitActionRequestActionType, appealId: String? = nil, block: BlockActionRequestPayload? = nil, bypass: BypassActionRequest? = nil, custom: CustomActionRequestPayload? = nil, deleteActivity: DeleteActivityRequestPayload? = nil, deleteComment: DeleteCommentRequestPayload? = nil, deletePoll: DeletePollRequestPayload? = nil, deletePollAnswer: DeletePollAnswerRequestPayload? = nil, deletePollOption: DeletePollOptionRequestPayload? = nil, deleteReaction: DeleteReactionRequestPayload? = nil, escalate: EscalatePayload? = nil, flag: FlagRequest? = nil, itemId: String? = nil, markReviewed: MarkReviewedRequestPayload? = nil, rejectAppeal: RejectAppealRequestPayload? = nil, restore: RestoreActionRequestPayload? = nil, shadowBlock: ShadowBlockActionRequestPayload? = nil, unblock: UnblockActionRequestPayload? = nil) {
        self.actionType = actionType
        self.appealId = appealId
        self.block = block
        self.bypass = bypass
        self.custom = custom
        self.deleteActivity = deleteActivity
        self.deleteComment = deleteComment
        self.deletePoll = deletePoll
        self.deletePollAnswer = deletePollAnswer
        self.deletePollOption = deletePollOption
        self.deleteReaction = deleteReaction
        self.escalate = escalate
        self.flag = flag
        self.itemId = itemId
        self.markReviewed = markReviewed
        self.rejectAppeal = rejectAppeal
        self.restore = restore
        self.shadowBlock = shadowBlock
        self._unblock = unblock
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case actionType = "action_type"
        case appealId = "appeal_id"
        case block
        case bypass
        case custom
        case deleteActivity = "delete_activity"
        case deleteComment = "delete_comment"
        case deletePoll = "delete_poll"
        case deletePollAnswer = "delete_poll_answer"
        case deletePollOption = "delete_poll_option"
        case deleteReaction = "delete_reaction"
        case escalate
        case flag
        case itemId = "item_id"
        case markReviewed = "mark_reviewed"
        case rejectAppeal = "reject_appeal"
        case restore
        case shadowBlock = "shadow_block"
        case unblock
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.actionType = try container.decode(SubmitActionRequestActionType.self, forKey: .actionType)
        self.appealId = try container.decodeIfPresent(String.self, forKey: .appealId)
        self.block = try container.decodeIfPresent(BlockActionRequestPayload.self, forKey: .block)
        self.bypass = try container.decodeIfPresent(BypassActionRequest.self, forKey: .bypass)
        self.custom = try container.decodeIfPresent(CustomActionRequestPayload.self, forKey: .custom)
        self.deleteActivity = try container.decodeIfPresent(DeleteActivityRequestPayload.self, forKey: .deleteActivity)
        self.deleteComment = try container.decodeIfPresent(DeleteCommentRequestPayload.self, forKey: .deleteComment)
        self.deletePoll = try container.decodeIfPresent(DeletePollRequestPayload.self, forKey: .deletePoll)
        self.deletePollAnswer = try container.decodeIfPresent(DeletePollAnswerRequestPayload.self, forKey: .deletePollAnswer)
        self.deletePollOption = try container.decodeIfPresent(DeletePollOptionRequestPayload.self, forKey: .deletePollOption)
        self.deleteReaction = try container.decodeIfPresent(DeleteReactionRequestPayload.self, forKey: .deleteReaction)
        self.escalate = try container.decodeIfPresent(EscalatePayload.self, forKey: .escalate)
        self.flag = try container.decodeIfPresent(FlagRequest.self, forKey: .flag)
        self.itemId = try container.decodeIfPresent(String.self, forKey: .itemId)
        self.markReviewed = try container.decodeIfPresent(MarkReviewedRequestPayload.self, forKey: .markReviewed)
        self.rejectAppeal = try container.decodeIfPresent(RejectAppealRequestPayload.self, forKey: .rejectAppeal)
        self.restore = try container.decodeIfPresent(RestoreActionRequestPayload.self, forKey: .restore)
        self.shadowBlock = try container.decodeIfPresent(ShadowBlockActionRequestPayload.self, forKey: .shadowBlock)
        self._unblock = try container.decodeIfPresent(UnblockActionRequestPayload.self, forKey: .unblock)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(actionType, forKey: .actionType)
        try container.encodeIfPresent(appealId, forKey: .appealId)
        try container.encodeIfPresent(block, forKey: .block)
        try container.encodeIfPresent(bypass, forKey: .bypass)
        try container.encodeIfPresent(custom, forKey: .custom)
        try container.encodeIfPresent(deleteActivity, forKey: .deleteActivity)
        try container.encodeIfPresent(deleteComment, forKey: .deleteComment)
        try container.encodeIfPresent(deletePoll, forKey: .deletePoll)
        try container.encodeIfPresent(deletePollAnswer, forKey: .deletePollAnswer)
        try container.encodeIfPresent(deletePollOption, forKey: .deletePollOption)
        try container.encodeIfPresent(deleteReaction, forKey: .deleteReaction)
        try container.encodeIfPresent(escalate, forKey: .escalate)
        try container.encodeIfPresent(flag, forKey: .flag)
        try container.encodeIfPresent(itemId, forKey: .itemId)
        try container.encodeIfPresent(markReviewed, forKey: .markReviewed)
        try container.encodeIfPresent(rejectAppeal, forKey: .rejectAppeal)
        try container.encodeIfPresent(restore, forKey: .restore)
        try container.encodeIfPresent(shadowBlock, forKey: .shadowBlock)
        try container.encodeIfPresent(_unblock, forKey: .unblock)
    }
}

extension SubmitActionRequest: Hashable {
    public static func == (lhs: SubmitActionRequest, rhs: SubmitActionRequest) -> Bool {
        lhs.actionType == rhs.actionType &&
            lhs.appealId == rhs.appealId &&
            lhs.block == rhs.block &&
            lhs.bypass == rhs.bypass &&
            lhs.custom == rhs.custom &&
            lhs.deleteActivity == rhs.deleteActivity &&
            lhs.deleteComment == rhs.deleteComment &&
            lhs.deletePoll == rhs.deletePoll &&
            lhs.deletePollAnswer == rhs.deletePollAnswer &&
            lhs.deletePollOption == rhs.deletePollOption &&
            lhs.deleteReaction == rhs.deleteReaction &&
            lhs.escalate == rhs.escalate &&
            lhs.flag == rhs.flag &&
            lhs.itemId == rhs.itemId &&
            lhs.markReviewed == rhs.markReviewed &&
            lhs.rejectAppeal == rhs.rejectAppeal &&
            lhs.restore == rhs.restore &&
            lhs.shadowBlock == rhs.shadowBlock &&
            lhs._unblock == rhs._unblock
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(actionType)
        hasher.combine(appealId)
        hasher.combine(block)
        hasher.combine(bypass)
        hasher.combine(custom)
        hasher.combine(deleteActivity)
        hasher.combine(deleteComment)
        hasher.combine(deletePoll)
        hasher.combine(deletePollAnswer)
        hasher.combine(deletePollOption)
        hasher.combine(deleteReaction)
        hasher.combine(escalate)
        hasher.combine(flag)
        hasher.combine(itemId)
        hasher.combine(markReviewed)
        hasher.combine(rejectAppeal)
        hasher.combine(restore)
        hasher.combine(shadowBlock)
        hasher.combine(_unblock)
    }
}
