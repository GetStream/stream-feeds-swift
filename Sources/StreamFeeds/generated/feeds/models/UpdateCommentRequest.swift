//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UpdateCommentRequest: @unchecked Sendable, Codable, JSONEncodable {
    /// Updated media attachments for the comment. Providing this field will replace all existing attachments.
    public var attachments: [Attachment]?
    /// Updated text content of the comment
    public var comment: String?
    /// Whether to copy custom data to the notification activity (only applies when handle_mention_notifications creates notifications) Deprecated: use notification_context.trigger.custom and notification_context.target.custom instead
    @available(*, deprecated, message: "use notification_context.trigger.custom and notification_context.target.custom instead")
    public var copyCustomToNotification: Bool? { get { _copyCustomToNotification } set { _copyCustomToNotification = newValue } }
    private var _copyCustomToNotification: Bool?
    /// Updated custom data for the comment
    public var custom: [String: RawJSON]?
    /// If true, creates notification activities for newly mentioned users and deletes notifications for users no longer mentioned
    public var handleMentionNotifications: Bool?
    /// List of user IDs mentioned in the comment
    public var mentionedUserIds: [String]?
    /// Whether to skip URL enrichment for this comment
    public var skipEnrichUrl: Bool?
    public var skipPush: Bool?

    public init(attachments: [Attachment]? = nil, comment: String? = nil, copyCustomToNotification: Bool? = nil, custom: [String: RawJSON]? = nil, handleMentionNotifications: Bool? = nil, mentionedUserIds: [String]? = nil, skipEnrichUrl: Bool? = nil, skipPush: Bool? = nil) {
        self.attachments = attachments
        self.comment = comment
        self._copyCustomToNotification = copyCustomToNotification
        self.custom = custom
        self.handleMentionNotifications = handleMentionNotifications
        self.mentionedUserIds = mentionedUserIds
        self.skipEnrichUrl = skipEnrichUrl
        self.skipPush = skipPush
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case attachments
        case comment
        case copyCustomToNotification = "copy_custom_to_notification"
        case custom
        case handleMentionNotifications = "handle_mention_notifications"
        case mentionedUserIds = "mentioned_user_ids"
        case skipEnrichUrl = "skip_enrich_url"
        case skipPush = "skip_push"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.attachments = try container.decodeIfPresent([Attachment].self, forKey: .attachments)
        self.comment = try container.decodeIfPresent(String.self, forKey: .comment)
        self._copyCustomToNotification = try container.decodeIfPresent(Bool.self, forKey: .copyCustomToNotification)
        self.custom = try container.decodeIfPresent([String: RawJSON].self, forKey: .custom)
        self.handleMentionNotifications = try container.decodeIfPresent(Bool.self, forKey: .handleMentionNotifications)
        self.mentionedUserIds = try container.decodeIfPresent([String].self, forKey: .mentionedUserIds)
        self.skipEnrichUrl = try container.decodeIfPresent(Bool.self, forKey: .skipEnrichUrl)
        self.skipPush = try container.decodeIfPresent(Bool.self, forKey: .skipPush)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(attachments, forKey: .attachments)
        try container.encodeIfPresent(comment, forKey: .comment)
        try container.encodeIfPresent(_copyCustomToNotification, forKey: .copyCustomToNotification)
        try container.encodeIfPresent(custom, forKey: .custom)
        try container.encodeIfPresent(handleMentionNotifications, forKey: .handleMentionNotifications)
        try container.encodeIfPresent(mentionedUserIds, forKey: .mentionedUserIds)
        try container.encodeIfPresent(skipEnrichUrl, forKey: .skipEnrichUrl)
        try container.encodeIfPresent(skipPush, forKey: .skipPush)
    }
}

extension UpdateCommentRequest: Hashable {
    public static func == (lhs: UpdateCommentRequest, rhs: UpdateCommentRequest) -> Bool {
        lhs.attachments == rhs.attachments &&
            lhs.comment == rhs.comment &&
            lhs._copyCustomToNotification == rhs._copyCustomToNotification &&
            lhs.custom == rhs.custom &&
            lhs.handleMentionNotifications == rhs.handleMentionNotifications &&
            lhs.mentionedUserIds == rhs.mentionedUserIds &&
            lhs.skipEnrichUrl == rhs.skipEnrichUrl &&
            lhs.skipPush == rhs.skipPush
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(attachments)
        hasher.combine(comment)
        hasher.combine(_copyCustomToNotification)
        hasher.combine(custom)
        hasher.combine(handleMentionNotifications)
        hasher.combine(mentionedUserIds)
        hasher.combine(skipEnrichUrl)
        hasher.combine(skipPush)
    }
}
