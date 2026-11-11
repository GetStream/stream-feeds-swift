//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// A request for adding comment when interacting with ``Activity``.
public struct ActivityAddCommentRequest: Sendable {
    private let attachments: [Attachment]?
    private let comment: String
    private let createNotificationActivity: Bool?
    private let custom: [String: RawJSON]?
    private let id: String?
    private let mentionedUserIds: [String]?
    private let parentId: String?
    private let skipEnrichUrl: Bool?
    private let skipPush: Bool?

    /// Creates a request for adding a comment to the activity.
    ///
    /// - Parameters:
    ///   - attachments: Media attachments for the comment.
    ///   - comment: The text of the comment.
    ///   - createNotificationActivity: Whether to create a notification activity for the comment. Backend default is false.
    ///   - custom: Custom data for the comment.
    ///   - id: A custom ID for the comment, at most 255 characters. Backend default generates a UUID.
    ///   - mentionedUserIds: IDs of the users mentioned in the comment.
    ///   - parentId: The ID of the parent comment when replying.
    ///   - skipEnrichUrl: Whether to skip URL enrichment. Backend default is false.
    ///   - skipPush: Whether to skip push notifications. Backend default is false.
    public init(
        attachments: [Attachment]? = nil,
        comment: String,
        createNotificationActivity: Bool? = nil,
        custom: [String: RawJSON]? = nil,
        id: String? = nil,
        mentionedUserIds: [String]? = nil,
        parentId: String? = nil,
        skipEnrichUrl: Bool? = nil,
        skipPush: Bool? = nil
    ) {
        self.attachments = attachments
        self.comment = comment
        self.createNotificationActivity = createNotificationActivity
        self.custom = custom
        self.id = id
        self.mentionedUserIds = mentionedUserIds
        self.parentId = parentId
        self.skipEnrichUrl = skipEnrichUrl
        self.skipPush = skipPush
    }

    func withActivityId(_ activityId: String) -> AddCommentRequest {
        AddCommentRequest(
            attachments: attachments,
            comment: comment,
            createNotificationActivity: createNotificationActivity,
            custom: custom,
            id: id,
            mentionedUserIds: mentionedUserIds,
            objectId: activityId,
            objectType: "activity",
            parentId: parentId,
            skipEnrichUrl: skipEnrichUrl,
            skipPush: skipPush
        )
    }
}
