//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// A request for adding activities when interacting with ``Feed``.
public struct FeedAddActivityRequest: Sendable {
    private let attachments: [Attachment]?
    let attachmentUploads: [AnyAttachmentPayload]?
    private let custom: [String: RawJSON]?
    private let expiresAt: String?
    private let filterTags: [String]?
    private let id: String?
    private let interestTags: [String]?
    private let location: Location?
    private let mentionedUserIds: [String]?
    private let parentId: String?
    private let pollId: String?
    private let searchData: [String: RawJSON]?
    private let text: String?
    private let type: String
    private let visibility: AddActivityRequestVisibility?
    private let visibilityTag: String?

    public init(
        attachments: [Attachment]? = nil,
        attachmentUploads: [AnyAttachmentPayload]? = nil,
        custom: [String: RawJSON]? = nil,
        expiresAt: String? = nil,
        filterTags: [String]? = nil,
        id: String? = nil,
        interestTags: [String]? = nil,
        location: Location? = nil,
        mentionedUserIds: [String]? = nil,
        parentId: String? = nil,
        pollId: String? = nil,
        searchData: [String: RawJSON]? = nil,
        text: String? = nil,
        type: String,
        visibility: AddActivityRequestVisibility? = nil,
        visibilityTag: String? = nil
    ) {
        self.attachments = attachments
        self.attachmentUploads = attachmentUploads
        self.custom = custom
        self.expiresAt = expiresAt
        self.filterTags = filterTags
        self.id = id
        self.interestTags = interestTags
        self.location = location
        self.mentionedUserIds = mentionedUserIds
        self.parentId = parentId
        self.pollId = pollId
        self.searchData = searchData
        self.text = text
        self.type = type
        self.visibility = visibility
        self.visibilityTag = visibilityTag
    }

    func withFeed(_ feed: FeedId, uploadedAttachments: [Attachment]) -> AddActivityRequest {
        let attachments = (attachments ?? []) + uploadedAttachments
        return AddActivityRequest(
            attachments: attachments.isEmpty ? nil : attachments,
            custom: custom,
            expiresAt: expiresAt,
            feeds: [feed.rawValue],
            filterTags: filterTags,
            id: id,
            interestTags: interestTags,
            location: location,
            mentionedUserIds: mentionedUserIds,
            parentId: parentId,
            pollId: pollId,
            searchData: searchData,
            text: text,
            type: type,
            visibility: visibility,
            visibilityTag: visibilityTag
        )
    }
}
