//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// This event is sent when a user gets deleted. The event contains information about the user that was deleted and the deletion options that were used.
public final class UserDeletedEvent: @unchecked Sendable, Event, Codable, JSONEncodable {
    /// Date/time of creation
    public var createdAt: Date
    public var custom: [String: RawJSON]
    /// The type of deletion that was used for the user's conversations. One of: hard, soft, pruning, (empty string)
    public var deleteConversation: String
    /// The type of deletion that was used for the user. One of: hard, soft, pruning, (empty string)
    public var deleteUser: String
    /// Whether the user was hard deleted
    public var hardDelete: Bool
    public var receivedAt: Date?
    /// The type of event: "user.deleted" in this case
    public var type: String = "user.deleted"
    public var user: UserResponseCommonFields

    public init(createdAt: Date, custom: [String: RawJSON], deleteConversation: String, deleteUser: String, hardDelete: Bool, receivedAt: Date? = nil, user: UserResponseCommonFields) {
        self.createdAt = createdAt
        self.custom = custom
        self.deleteConversation = deleteConversation
        self.deleteUser = deleteUser
        self.hardDelete = hardDelete
        self.receivedAt = receivedAt
        self.user = user
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case createdAt = "created_at"
        case custom
        case deleteConversation = "delete_conversation"
        case deleteUser = "delete_user"
        case hardDelete = "hard_delete"
        case receivedAt = "received_at"
        case type
        case user
    }
}

extension UserDeletedEvent: Hashable {
    public static func == (lhs: UserDeletedEvent, rhs: UserDeletedEvent) -> Bool {
        lhs.createdAt == rhs.createdAt &&
            lhs.custom == rhs.custom &&
            lhs.deleteConversation == rhs.deleteConversation &&
            lhs.deleteUser == rhs.deleteUser &&
            lhs.hardDelete == rhs.hardDelete &&
            lhs.receivedAt == rhs.receivedAt &&
            lhs.type == rhs.type &&
            lhs.user == rhs.user
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(createdAt)
        hasher.combine(custom)
        hasher.combine(deleteConversation)
        hasher.combine(deleteUser)
        hasher.combine(hardDelete)
        hasher.combine(receivedAt)
        hasher.combine(type)
        hasher.combine(user)
    }
}
