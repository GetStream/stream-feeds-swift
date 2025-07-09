//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class SubmitActionRequest: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public enum SubmitActionRequestActionType: String, Sendable, Codable, CaseIterable {
        case ban
        case custom
        case deleteActivity = "delete_activity"
        case deleteMessage = "delete_message"
        case deleteReaction = "delete_reaction"
        case deleteUser = "delete_user"
        case endCall = "end_call"
        case kickUser = "kick_user"
        case markReviewed = "mark_reviewed"
        case restore
        case shadowBlock = "shadow_block"
        case unban
        case unblock
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

    public var actionType: SubmitActionRequestActionType
    public var ban: BanActionRequest?
    public var custom: CustomActionRequest?
    public var deleteActivity: DeleteActivityRequest?
    public var deleteMessage: DeleteMessageRequest?
    public var deleteReaction: DeleteReactionRequest?
    public var deleteUser: DeleteUserRequest?
    public var itemId: String
    public var markReviewed: MarkReviewedRequest?

    public init(actionType: SubmitActionRequestActionType, ban: BanActionRequest? = nil, custom: CustomActionRequest? = nil, deleteActivity: DeleteActivityRequest? = nil, deleteMessage: DeleteMessageRequest? = nil, deleteReaction: DeleteReactionRequest? = nil, deleteUser: DeleteUserRequest? = nil, itemId: String, markReviewed: MarkReviewedRequest? = nil) {
        self.actionType = actionType
        self.ban = ban
        self.custom = custom
        self.deleteActivity = deleteActivity
        self.deleteMessage = deleteMessage
        self.deleteReaction = deleteReaction
        self.deleteUser = deleteUser
        self.itemId = itemId
        self.markReviewed = markReviewed
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case actionType = "action_type"
        case ban
        case custom
        case deleteActivity = "delete_activity"
        case deleteMessage = "delete_message"
        case deleteReaction = "delete_reaction"
        case deleteUser = "delete_user"
        case itemId = "item_id"
        case markReviewed = "mark_reviewed"
    }

    public static func == (lhs: SubmitActionRequest, rhs: SubmitActionRequest) -> Bool {
        lhs.actionType == rhs.actionType &&
            lhs.ban == rhs.ban &&
            lhs.custom == rhs.custom &&
            lhs.deleteActivity == rhs.deleteActivity &&
            lhs.deleteMessage == rhs.deleteMessage &&
            lhs.deleteReaction == rhs.deleteReaction &&
            lhs.deleteUser == rhs.deleteUser &&
            lhs.itemId == rhs.itemId &&
            lhs.markReviewed == rhs.markReviewed
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(actionType)
        hasher.combine(ban)
        hasher.combine(custom)
        hasher.combine(deleteActivity)
        hasher.combine(deleteMessage)
        hasher.combine(deleteReaction)
        hasher.combine(deleteUser)
        hasher.combine(itemId)
        hasher.combine(markReviewed)
    }
}
