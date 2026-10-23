//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class AddCommentRequest: Sendable, Codable, JSONEncodable {
    /// Media attachments for the reply
    public let attachments: [Attachment]?
    /// Text content of the comment
    public let comment: String?
    /// Whether to copy custom data to the notification activity (only applies when create_notification_activity is true) Deprecated: use notification_context.trigger.custom and notification_context.target.custom instead
    @available(*, deprecated, message: "use notification_context.trigger.custom and notification_context.target.custom instead")
    public var copyCustomToNotification: Bool? { _copyCustomToNotification }
    private let _copyCustomToNotification: Bool?
    /// Whether to create a notification activity for this comment
    public let createNotificationActivity: Bool?
    /// Custom data for the comment
    public let custom: [String: RawJSON]?
    /// Optional custom ID for the comment (max 255 characters). If not provided, a UUID will be generated.
    public let id: String?
    /// List of users mentioned in the reply
    public let mentionedUserIds: [String]?
    /// ID of the object to comment on. Required for root comments
    public let objectId: String?
    /// Type of the object to comment on. Required for root comments
    public let objectType: String?
    /// ID of parent comment for replies. When provided, object_id and object_type are automatically inherited from the parent comment.
    public let parentId: String?
    /// Whether to skip URL enrichment for this comment
    public let skipEnrichUrl: Bool?
    public let skipPush: Bool?

    public init(attachments: [Attachment]? = nil, comment: String? = nil, copyCustomToNotification: Bool? = nil, createNotificationActivity: Bool? = nil, custom: [String: RawJSON]? = nil, id: String? = nil, mentionedUserIds: [String]? = nil, objectId: String? = nil, objectType: String? = nil, parentId: String? = nil, skipEnrichUrl: Bool? = nil, skipPush: Bool? = nil) {
        self.attachments = attachments
        self.comment = comment
        self._copyCustomToNotification = copyCustomToNotification
        self.createNotificationActivity = createNotificationActivity
        self.custom = custom
        self.id = id
        self.mentionedUserIds = mentionedUserIds
        self.objectId = objectId
        self.objectType = objectType
        self.parentId = parentId
        self.skipEnrichUrl = skipEnrichUrl
        self.skipPush = skipPush
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.attachments = try container.decodeIfPresent([Attachment].self, forKey: .attachments)
        self.comment = try container.decodeIfPresent(String.self, forKey: .comment)
        self._copyCustomToNotification = try container.decodeIfPresent(Bool.self, forKey: .copyCustomToNotification)
        self.createNotificationActivity = try container.decodeIfPresent(Bool.self, forKey: .createNotificationActivity)
        self.custom = try container.decodeIfPresent([String: RawJSON].self, forKey: .custom)
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.mentionedUserIds = try container.decodeIfPresent([String].self, forKey: .mentionedUserIds)
        self.objectId = try container.decodeIfPresent(String.self, forKey: .objectId)
        self.objectType = try container.decodeIfPresent(String.self, forKey: .objectType)
        self.parentId = try container.decodeIfPresent(String.self, forKey: .parentId)
        self.skipEnrichUrl = try container.decodeIfPresent(Bool.self, forKey: .skipEnrichUrl)
        self.skipPush = try container.decodeIfPresent(Bool.self, forKey: .skipPush)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(attachments, forKey: .attachments)
        try container.encodeIfPresent(comment, forKey: .comment)
        try container.encodeIfPresent(_copyCustomToNotification, forKey: .copyCustomToNotification)
        try container.encodeIfPresent(createNotificationActivity, forKey: .createNotificationActivity)
        try container.encodeIfPresent(custom, forKey: .custom)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(mentionedUserIds, forKey: .mentionedUserIds)
        try container.encodeIfPresent(objectId, forKey: .objectId)
        try container.encodeIfPresent(objectType, forKey: .objectType)
        try container.encodeIfPresent(parentId, forKey: .parentId)
        try container.encodeIfPresent(skipEnrichUrl, forKey: .skipEnrichUrl)
        try container.encodeIfPresent(skipPush, forKey: .skipPush)
    }
}

extension AddCommentRequest: Hashable {
    public static func == (lhs: AddCommentRequest, rhs: AddCommentRequest) -> Bool {
        lhs.attachments == rhs.attachments &&
            lhs.comment == rhs.comment &&
            lhs._copyCustomToNotification == rhs._copyCustomToNotification &&
            lhs.createNotificationActivity == rhs.createNotificationActivity &&
            lhs.custom == rhs.custom &&
            lhs.id == rhs.id &&
            lhs.mentionedUserIds == rhs.mentionedUserIds &&
            lhs.objectId == rhs.objectId &&
            lhs.objectType == rhs.objectType &&
            lhs.parentId == rhs.parentId &&
            lhs.skipEnrichUrl == rhs.skipEnrichUrl &&
            lhs.skipPush == rhs.skipPush
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(attachments)
        hasher.combine(comment)
        hasher.combine(_copyCustomToNotification)
        hasher.combine(createNotificationActivity)
        hasher.combine(custom)
        hasher.combine(id)
        hasher.combine(mentionedUserIds)
        hasher.combine(objectId)
        hasher.combine(objectType)
        hasher.combine(parentId)
        hasher.combine(skipEnrichUrl)
        hasher.combine(skipPush)
    }
}
