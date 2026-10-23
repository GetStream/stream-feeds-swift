//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class NotificationComment: @unchecked Sendable, Codable, JSONEncodable {
    /// Attachments on the comment
    public var attachments: [Attachment]?
    /// The text of the comment
    public var comment: String
    /// The ID of the comment
    public var id: String
    /// The ID of the parent comment when this comment is a reply; omitted for top-level comments
    public var parentId: String?
    /// The ID of the user who wrote the comment
    public var userId: String

    public init(attachments: [Attachment]? = nil, comment: String, id: String, parentId: String? = nil, userId: String) {
        self.attachments = attachments
        self.comment = comment
        self.id = id
        self.parentId = parentId
        self.userId = userId
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case attachments
        case comment
        case id
        case parentId = "parent_id"
        case userId = "user_id"
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
