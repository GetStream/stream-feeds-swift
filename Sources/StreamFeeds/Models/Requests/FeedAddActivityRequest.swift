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
    private let createNotificationActivity: Bool?
    private let custom: [String: RawJSON]?
    private let enrichOwnFields: Bool?
    private let expiresAt: String?
    private let filterTags: [String]?
    private let id: String?
    private let interestTags: [String]?
    private let location: Location?
    private let mentionedUserIds: [String]?
    private let parentId: String?
    private let pollId: String?
    private let restrictReplies: RestrictReplies?
    private let searchData: [String: RawJSON]?
    private let skipEnrichUrl: Bool?
    private let skipPush: Bool?
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
    ///   - createNotificationActivity: Whether to create notification activities for mentioned users. Backend default is false.
    ///   - custom: Custom data for the activity.
    ///   - enrichOwnFields: If true, enriches the activity's current feed with the current user's own fields. Backend default is false.
    ///   - expiresAt: When the activity expires, as an RFC 3339 date-time, for example `2026-01-01T00:00:00Z`.
    ///   - filterTags: Tags for filtering activities.
    ///   - id: A custom ID for the activity.
    ///   - interestTags: Tags for interest-based ranking.
    ///   - location: The geographic location of the activity.
    ///   - mentionedUserIds: IDs of the users mentioned in the activity.
    ///   - parentId: The ID of the parent activity.
    ///   - pollId: The ID of a poll to attach.
    ///   - restrictReplies: Who can comment on the activity. Backend default is `.everyone`.
    ///   - searchData: Additional data for search indexing.
    ///   - skipEnrichUrl: Whether to skip URL enrichment. Backend default is false.
    ///   - skipPush: Whether to skip push notifications. Backend default is false.
    ///   - text: The text of the activity.
    ///   - type: The type of the activity, for example `post`.
    ///   - visibility: Who can see the activity.
    ///   - visibilityTag: The tag name when `visibility` is `.tag`.
    public init(
        attachments: [Attachment]? = nil,
        attachmentUploads: [AnyAttachmentPayload]? = nil,
        collectionReferences: [String]? = nil,
        collections: [CollectionRequest]? = nil,
        createNotificationActivity: Bool? = nil,
        custom: [String: RawJSON]? = nil,
        enrichOwnFields: Bool? = nil,
        expiresAt: String? = nil,
        filterTags: [String]? = nil,
        id: String? = nil,
        interestTags: [String]? = nil,
        location: Location? = nil,
        mentionedUserIds: [String]? = nil,
        parentId: String? = nil,
        pollId: String? = nil,
        restrictReplies: RestrictReplies? = nil,
        searchData: [String: RawJSON]? = nil,
        skipEnrichUrl: Bool? = nil,
        skipPush: Bool? = nil,
        text: String? = nil,
        type: String,
        visibility: ActivityVisibility? = nil,
        visibilityTag: String? = nil
    ) {
        self.attachments = attachments
        self.attachmentUploads = attachmentUploads
        self.collectionReferences = collectionReferences
        self.collections = collections
        self.createNotificationActivity = createNotificationActivity
        self.custom = custom
        self.enrichOwnFields = enrichOwnFields
        self.expiresAt = expiresAt
        self.filterTags = filterTags
        self.id = id
        self.interestTags = interestTags
        self.location = location
        self.mentionedUserIds = mentionedUserIds
        self.parentId = parentId
        self.pollId = pollId
        self.restrictReplies = restrictReplies
        self.searchData = searchData
        self.skipEnrichUrl = skipEnrichUrl
        self.skipPush = skipPush
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
            createNotificationActivity: createNotificationActivity,
            custom: custom,
            enrichOwnFields: enrichOwnFields,
            expiresAt: expiresAt,
            feeds: [feed.rawValue],
            filterTags: filterTags,
            id: id,
            interestTags: interestTags,
            location: location,
            mentionedUserIds: mentionedUserIds,
            parentId: parentId,
            pollId: pollId,
            restrictReplies: restrictReplies,
            searchData: searchData,
            skipEnrichUrl: skipEnrichUrl,
            skipPush: skipPush,
            text: text,
            type: type,
            visibility: visibility,
            visibilityTag: visibilityTag
        )
    }
}
