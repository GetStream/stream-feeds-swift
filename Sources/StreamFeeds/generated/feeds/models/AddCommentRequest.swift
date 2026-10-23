//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class AddCommentRequest: Sendable, Encodable, JSONEncodable {
    /// Media attachments for the reply
    public let attachments: [Attachment]?
    /// Text content of the comment
    public let comment: String?
    /// Whether to create a notification activity for this comment
    public let createNotificationActivity: Bool?
    /// Custom data for the comment
    public let custom: [String: RawJSON]?
    /// List of users mentioned in the reply
    public let mentionedUserIds: [String]?
    /// ID of the object to comment on. Required for root comments
    public let objectId: String?
    /// Type of the object to comment on. Required for root comments
    public let objectType: String?
    /// ID of parent comment for replies. When provided, object_id and object_type are automatically inherited from the parent comment.
    public let parentId: String?
    public let skipPush: Bool?

    public init(attachments: [Attachment]? = nil, comment: String? = nil, createNotificationActivity: Bool? = nil, custom: [String: RawJSON]? = nil, mentionedUserIds: [String]? = nil, objectId: String? = nil, objectType: String? = nil, parentId: String? = nil, skipPush: Bool? = nil) {
        self.attachments = attachments
        self.comment = comment
        self.createNotificationActivity = createNotificationActivity
        self.custom = custom
        self.mentionedUserIds = mentionedUserIds
        self.objectId = objectId
        self.objectType = objectType
        self.parentId = parentId
        self.skipPush = skipPush
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(attachments, forKey: .attachments)
        try container.encodeIfPresent(comment, forKey: .comment)
        try container.encodeIfPresent(createNotificationActivity, forKey: .createNotificationActivity)
        try container.encodeIfPresent(custom, forKey: .custom)
        try container.encodeIfPresent(mentionedUserIds, forKey: .mentionedUserIds)
        try container.encodeIfPresent(objectId, forKey: .objectId)
        try container.encodeIfPresent(objectType, forKey: .objectType)
        try container.encodeIfPresent(parentId, forKey: .parentId)
        try container.encodeIfPresent(skipPush, forKey: .skipPush)
    }
}

extension AddCommentRequest: Hashable {
    public static func == (lhs: AddCommentRequest, rhs: AddCommentRequest) -> Bool {
        lhs.attachments == rhs.attachments &&
            lhs.comment == rhs.comment &&
            lhs.createNotificationActivity == rhs.createNotificationActivity &&
            lhs.custom == rhs.custom &&
            lhs.mentionedUserIds == rhs.mentionedUserIds &&
            lhs.objectId == rhs.objectId &&
            lhs.objectType == rhs.objectType &&
            lhs.parentId == rhs.parentId &&
            lhs.skipPush == rhs.skipPush
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(attachments)
        hasher.combine(comment)
        hasher.combine(createNotificationActivity)
        hasher.combine(custom)
        hasher.combine(mentionedUserIds)
        hasher.combine(objectId)
        hasher.combine(objectType)
        hasher.combine(parentId)
        hasher.combine(skipPush)
    }
}
