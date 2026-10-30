//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// This event is sent when a user gets deleted. The event contains information about the user that was deleted and the deletion options that were used.
public final class UserDeletedEvent: Sendable, Event, Decodable {
    /// Date/time of creation
    public let createdAt: Date
    public let custom: [String: RawJSON]
    /// The type of deletion that was used for the user's conversations. One of: hard, soft, pruning, (empty string)
    public let deleteConversation: String
    /// The type of deletion that was used for the user. One of: hard, soft, pruning, (empty string)
    public let deleteUser: String
    /// Whether the user was hard deleted
    public let hardDelete: Bool
    public let receivedAt: Date?
    /// The type of event: "user.deleted" in this case
    public let type: String
    public let user: UserResponseCommonFields

    public init(createdAt: Date, custom: [String: RawJSON], deleteConversation: String, deleteUser: String, hardDelete: Bool, receivedAt: Date? = nil, type: String = "user.deleted", user: UserResponseCommonFields) {
        self.createdAt = createdAt
        self.custom = custom
        self.deleteConversation = deleteConversation
        self.deleteUser = deleteUser
        self.hardDelete = hardDelete
        self.receivedAt = receivedAt
        self.type = type
        self.user = user
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.custom = try container.decode([String: RawJSON].self, forKey: .custom)
        self.deleteConversation = try container.decode(String.self, forKey: .deleteConversation)
        self.deleteUser = try container.decode(String.self, forKey: .deleteUser)
        self.hardDelete = try container.decode(Bool.self, forKey: .hardDelete)
        self.receivedAt = try container.decodeIfPresent(Date.self, forKey: .receivedAt)
        self.type = try container.decode(String.self, forKey: .type)
        self.user = try container.decode(UserResponseCommonFields.self, forKey: .user)
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
