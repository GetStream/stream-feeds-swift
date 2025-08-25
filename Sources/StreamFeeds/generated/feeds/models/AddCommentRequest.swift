//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class AddCommentRequest: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var attachments: [Attachment]?
    public var comment: String
    public var createNotificationActivity: Bool?
    public var custom: [String: RawJSON]?
    public var mentionedUserIds: [String]?
    public var objectId: String
    public var objectType: String
    public var parentId: String?
    public var skipPush: Bool?

    public init(attachments: [Attachment]? = nil, comment: String, createNotificationActivity: Bool? = nil, custom: [String: RawJSON]? = nil, mentionedUserIds: [String]? = nil, objectId: String, objectType: String, parentId: String? = nil, skipPush: Bool? = nil) {
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
