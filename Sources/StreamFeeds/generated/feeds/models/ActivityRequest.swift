//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class ActivityRequest: Sendable, Encodable, JSONEncodable {
    /// List of attachments for the activity
    public let attachments: [Attachment]?
    /// Collections that this activity references
    public let collectionRefs: [String]?
    /// Collections to create or update as part of this request, so an activity and the collections it references can be written in one call. Their refs (name:id) are added to collection_refs automatically; you do not need to restate them, and they count toward the same per-activity collection-reference limit, which is the effective cap here. A collection that already exists has its custom data updated. Use collection_refs instead when the collection already exists and you are only referencing it, which requires no collection permissions.
    public let collections: [CollectionRequest]?
    /// Custom data for the activity
    public let custom: [String: RawJSON]?
    /// Expiration time for the activity
    public let expiresAt: String?
    /// List of feeds to add the activity to with a default max limit of 25 feeds
    public let feeds: [String]
    /// Tags for filtering activities
    public let filterTags: [String]?
    /// Optional ID for the activity
    public let id: String?
    /// Tags for indicating user interests
    public let interestTags: [String]?
    public let location: Location?
    /// List of users mentioned in the activity
    public let mentionedUserIds: [String]?
    /// ID of parent activity for replies/comments
    public let parentId: String?
    /// ID of a poll to attach to activity
    public let pollId: String?
    /// Additional data for search indexing
    public let searchData: [String: RawJSON]?
    /// Text content of the activity
    public let text: String?
    /// Type of activity
    public let type: String
    /// Visibility setting for the activity. One of: public, private, tag
    public let visibility: ActivityVisibility?
    /// If visibility is 'tag', this is the tag name and is required
    public let visibilityTag: String?

    public init(attachments: [Attachment]? = nil, collectionRefs: [String]? = nil, collections: [CollectionRequest]? = nil, custom: [String: RawJSON]? = nil, expiresAt: String? = nil, feeds: [String], filterTags: [String]? = nil, id: String? = nil, interestTags: [String]? = nil, location: Location? = nil, mentionedUserIds: [String]? = nil, parentId: String? = nil, pollId: String? = nil, searchData: [String: RawJSON]? = nil, text: String? = nil, type: String, visibility: ActivityVisibility? = nil, visibilityTag: String? = nil) {
        self.attachments = attachments
        self.collectionRefs = collectionRefs
        self.collections = collections
        self.custom = custom
        self.expiresAt = expiresAt
        self.feeds = feeds
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

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(attachments, forKey: .attachments)
        try container.encodeIfPresent(collectionRefs, forKey: .collectionRefs)
        try container.encodeIfPresent(collections, forKey: .collections)
        try container.encodeIfPresent(custom, forKey: .custom)
        try container.encodeIfPresent(expiresAt, forKey: .expiresAt)
        try container.encode(feeds, forKey: .feeds)
        try container.encodeIfPresent(filterTags, forKey: .filterTags)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(interestTags, forKey: .interestTags)
        try container.encodeIfPresent(location, forKey: .location)
        try container.encodeIfPresent(mentionedUserIds, forKey: .mentionedUserIds)
        try container.encodeIfPresent(parentId, forKey: .parentId)
        try container.encodeIfPresent(pollId, forKey: .pollId)
        try container.encodeIfPresent(searchData, forKey: .searchData)
        try container.encodeIfPresent(text, forKey: .text)
        try container.encode(type, forKey: .type)
        try container.encodeIfPresent(visibility, forKey: .visibility)
        try container.encodeIfPresent(visibilityTag, forKey: .visibilityTag)
    }
}

extension ActivityRequest: Hashable {
    public static func == (lhs: ActivityRequest, rhs: ActivityRequest) -> Bool {
        lhs.attachments == rhs.attachments &&
            lhs.collectionRefs == rhs.collectionRefs &&
            lhs.collections == rhs.collections &&
            lhs.custom == rhs.custom &&
            lhs.expiresAt == rhs.expiresAt &&
            lhs.feeds == rhs.feeds &&
            lhs.filterTags == rhs.filterTags &&
            lhs.id == rhs.id &&
            lhs.interestTags == rhs.interestTags &&
            lhs.location == rhs.location &&
            lhs.mentionedUserIds == rhs.mentionedUserIds &&
            lhs.parentId == rhs.parentId &&
            lhs.pollId == rhs.pollId &&
            lhs.searchData == rhs.searchData &&
            lhs.text == rhs.text &&
            lhs.type == rhs.type &&
            lhs.visibility == rhs.visibility &&
            lhs.visibilityTag == rhs.visibilityTag
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(attachments)
        hasher.combine(collectionRefs)
        hasher.combine(collections)
        hasher.combine(custom)
        hasher.combine(expiresAt)
        hasher.combine(feeds)
        hasher.combine(filterTags)
        hasher.combine(id)
        hasher.combine(interestTags)
        hasher.combine(location)
        hasher.combine(mentionedUserIds)
        hasher.combine(parentId)
        hasher.combine(pollId)
        hasher.combine(searchData)
        hasher.combine(text)
        hasher.combine(type)
        hasher.combine(visibility)
        hasher.combine(visibilityTag)
    }
}
