//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// A request for adding activities when interacting with ``Feed``.
public struct FeedAddActivityRequest: Sendable {
    private let attachments: [Attachment]?
    let attachmentUploads: [AnyAttachmentPayload]?
    private let collectionReferences: [String]?
    private let collections: [CollectionRequest]?
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
    private let visibility: ActivityVisibility?
    private let visibilityTag: String?

    /// Creates a request for adding an activity to the feed.
    ///
    /// - Parameters:
    ///   - attachments: Media attachments that are already uploaded.
    ///   - attachmentUploads: Local attachments to upload before the activity is added.
    ///   - collectionReferences: References to existing collections, in the `name:id` format.
    ///   - collections: Collections to create or update together with the activity. Their references are added to `collectionReferences`.
    ///   - custom: Custom data for the activity.
    ///   - expiresAt: When the activity expires, as an ISO 8601 date.
    ///   - filterTags: Tags for filtering activities.
    ///   - id: A custom ID for the activity.
    ///   - interestTags: Tags for interest-based ranking.
    ///   - location: The geographic location of the activity.
    ///   - mentionedUserIds: IDs of the users mentioned in the activity.
    ///   - parentId: The ID of the parent activity.
    ///   - pollId: The ID of a poll to attach.
    ///   - searchData: Additional data for search indexing.
    ///   - text: The text of the activity.
    ///   - type: The type of the activity, for example `post`.
    ///   - visibility: Who can see the activity.
    ///   - visibilityTag: The tag name when `visibility` is `.tag`.
    public init(
        attachments: [Attachment]? = nil,
        attachmentUploads: [AnyAttachmentPayload]? = nil,
        collectionReferences: [String]? = nil,
        collections: [CollectionRequest]? = nil,
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
        visibility: ActivityVisibility? = nil,
        visibilityTag: String? = nil
    ) {
        self.attachments = attachments
        self.attachmentUploads = attachmentUploads
        self.collectionReferences = collectionReferences
        self.collections = collections
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
            collectionRefs: collectionReferences,
            collections: collections,
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
