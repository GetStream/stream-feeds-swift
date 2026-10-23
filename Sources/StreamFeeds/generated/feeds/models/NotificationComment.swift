//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class NotificationComment: Sendable, Codable, JSONEncodable {
    /// Attachments on the comment
    public let attachments: [Attachment]?
    /// The text of the comment
    public let comment: String
    /// The ID of the comment
    public let id: String
    /// The ID of the parent comment when this comment is a reply; omitted for top-level comments
    public let parentId: String?
    /// The ID of the user who wrote the comment
    public let userId: String

    public init(attachments: [Attachment]? = nil, comment: String, id: String, parentId: String? = nil, userId: String) {
        self.attachments = attachments
        self.comment = comment
        self.id = id
        self.parentId = parentId
        self.userId = userId
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.attachments = try container.decodeIfPresent([Attachment].self, forKey: .attachments)
        self.comment = try container.decode(String.self, forKey: .comment)
        self.id = try container.decode(String.self, forKey: .id)
        self.parentId = try container.decodeIfPresent(String.self, forKey: .parentId)
        self.userId = try container.decode(String.self, forKey: .userId)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(attachments, forKey: .attachments)
        try container.encode(comment, forKey: .comment)
        try container.encode(id, forKey: .id)
        try container.encodeIfPresent(parentId, forKey: .parentId)
        try container.encode(userId, forKey: .userId)
    }
}

extension NotificationComment: Hashable {
    public static func == (lhs: NotificationComment, rhs: NotificationComment) -> Bool {
        lhs.attachments == rhs.attachments &&
            lhs.comment == rhs.comment &&
            lhs.id == rhs.id &&
            lhs.parentId == rhs.parentId &&
            lhs.userId == rhs.userId
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(attachments)
        hasher.combine(comment)
        hasher.combine(id)
        hasher.combine(parentId)
        hasher.combine(userId)
    }
}
