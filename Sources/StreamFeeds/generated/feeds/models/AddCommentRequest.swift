//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class AddCommentRequest: @unchecked Sendable, Codable, JSONEncodable {
    /// Media attachments for the reply
    public var attachments: [Attachment]?
    /// Text content of the comment
    public var comment: String?
    /// Whether to create a notification activity for this comment
    public var createNotificationActivity: Bool?
    /// Custom data for the comment
    public var custom: [String: RawJSON]?
    /// List of users mentioned in the reply
    public var mentionedUserIds: [String]?
    /// ID of the object to comment on. Required for root comments
    public var objectId: String?
    /// Type of the object to comment on. Required for root comments
    public var objectType: String?
    /// ID of parent comment for replies. When provided, object_id and object_type are automatically inherited from the parent comment.
    public var parentId: String?
    public var skipPush: Bool?

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

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case attachments
        case comment
        case createNotificationActivity = "create_notification_activity"
        case custom
        case mentionedUserIds = "mentioned_user_ids"
        case objectId = "object_id"
        case objectType = "object_type"
        case parentId = "parent_id"
        case skipPush = "skip_push"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.attachments = try container.decodeIfPresent([Attachment].self, forKey: .attachments)
        self.comment = try container.decodeIfPresent(String.self, forKey: .comment)
        self.createNotificationActivity = try container.decodeIfPresent(Bool.self, forKey: .createNotificationActivity)
        self.custom = try container.decodeIfPresent([String: RawJSON].self, forKey: .custom)
        self.mentionedUserIds = try container.decodeIfPresent([String].self, forKey: .mentionedUserIds)
        self.objectId = try container.decodeIfPresent(String.self, forKey: .objectId)
        self.objectType = try container.decodeIfPresent(String.self, forKey: .objectType)
        self.parentId = try container.decodeIfPresent(String.self, forKey: .parentId)
        self.skipPush = try container.decodeIfPresent(Bool.self, forKey: .skipPush)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
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
