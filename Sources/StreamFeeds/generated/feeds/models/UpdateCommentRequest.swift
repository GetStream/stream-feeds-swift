//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UpdateCommentRequest: Sendable, Encodable, JSONEncodable {
    /// Updated media attachments for the comment. Providing this field will replace all existing attachments.
    public let attachments: [Attachment]?
    /// Updated text content of the comment
    public let comment: String?
    /// Updated custom data for the comment
    public let custom: [String: RawJSON]?
    /// If true, creates notification activities for newly mentioned users and deletes notifications for users no longer mentioned
    public let handleMentionNotifications: Bool?
    /// List of user IDs mentioned in the comment
    public let mentionedUserIds: [String]?
    /// Whether to skip URL enrichment for this comment
    public let skipEnrichUrl: Bool?
    public let skipPush: Bool?

    public init(attachments: [Attachment]? = nil, comment: String? = nil, custom: [String: RawJSON]? = nil, handleMentionNotifications: Bool? = nil, mentionedUserIds: [String]? = nil, skipEnrichUrl: Bool? = nil, skipPush: Bool? = nil) {
        self.attachments = attachments
        self.comment = comment
        self.custom = custom
        self.handleMentionNotifications = handleMentionNotifications
        self.mentionedUserIds = mentionedUserIds
        self.skipEnrichUrl = skipEnrichUrl
        self.skipPush = skipPush
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(attachments, forKey: .attachments)
        try container.encodeIfPresent(comment, forKey: .comment)
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
            lhs.custom == rhs.custom &&
            lhs.handleMentionNotifications == rhs.handleMentionNotifications &&
            lhs.mentionedUserIds == rhs.mentionedUserIds &&
            lhs.skipEnrichUrl == rhs.skipEnrichUrl &&
            lhs.skipPush == rhs.skipPush
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(attachments)
        hasher.combine(comment)
        hasher.combine(custom)
        hasher.combine(handleMentionNotifications)
        hasher.combine(mentionedUserIds)
        hasher.combine(skipEnrichUrl)
        hasher.combine(skipPush)
    }
}
