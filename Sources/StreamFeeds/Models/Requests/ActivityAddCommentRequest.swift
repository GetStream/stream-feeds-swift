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
    private let mentionedUserIds: [String]?
    private let parentId: String?

    public init(
        attachments: [Attachment]? = nil,
        comment: String,
        createNotificationActivity: Bool? = nil,
        custom: [String: RawJSON]? = nil,
        mentionedUserIds: [String]? = nil,
        parentId: String? = nil
    ) {
        self.attachments = attachments
        self.comment = comment
        self.createNotificationActivity = createNotificationActivity
        self.custom = custom
        self.mentionedUserIds = mentionedUserIds
        self.parentId = parentId
    }

    func withActivityId(_ id: String) -> AddCommentRequest {
        AddCommentRequest(
            attachments: attachments,
            comment: comment,
            createNotificationActivity: createNotificationActivity,
            custom: custom,
            mentionedUserIds: mentionedUserIds,
            objectId: id,
            objectType: "activity",
            parentId: parentId
        )
    }
}
