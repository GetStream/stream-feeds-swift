//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class AddActivityRequest: @unchecked Sendable, Codable, JSONEncodable {
    /// List of attachments for the activity
    public var attachments: [Attachment]?
    /// Collections that this activity references
    public var collectionRefs: [String]?
    /// Whether to create notification activities for mentioned users
    public var createNotificationActivity: Bool?
    /// Custom data for the activity
    public var custom: [String: RawJSON]?
    /// Expiration time for the activity
    public var expiresAt: String?
    /// List of feeds to add the activity to with a default max limit of 25 feeds
    public var feeds: [String]
    /// Tags for filtering activities
    public var filterTags: [String]?
    /// Optional ID for the activity
    public var id: String?
    /// Tags for indicating user interests
    public var interestTags: [String]?
    public var location: Location?
    /// List of users mentioned in the activity
    public var mentionedUserIds: [String]?
    /// ID of parent activity for replies/comments
    public var parentId: String?
    /// ID of a poll to attach to activity
    public var pollId: String?
    /// Controls who can add comments/replies to this activity. One of: everyone, people_i_follow, nobody
    public var restrictReplies: RestrictReplies?
    /// Additional data for search indexing
    public var searchData: [String: RawJSON]?
    /// Whether to skip URL enrichment for the activity
    public var skipEnrichUrl: Bool?
    /// Whether to skip push notifications
    public var skipPush: Bool?
    /// Text content of the activity
    public var text: String?
    /// Type of activity
    public var type: String
    /// Visibility setting for the activity. One of: public, private, tag
    public var visibility: ActivityVisibility?
    /// If visibility is 'tag', this is the tag name and is required
    public var visibilityTag: String?

    public init(attachments: [Attachment]? = nil, collectionRefs: [String]? = nil, createNotificationActivity: Bool? = nil, custom: [String: RawJSON]? = nil, expiresAt: String? = nil, feeds: [String], filterTags: [String]? = nil, id: String? = nil, interestTags: [String]? = nil, location: Location? = nil, mentionedUserIds: [String]? = nil, parentId: String? = nil, pollId: String? = nil, restrictReplies: RestrictReplies? = nil, searchData: [String: RawJSON]? = nil, skipEnrichUrl: Bool? = nil, skipPush: Bool? = nil, text: String? = nil, type: String, visibility: ActivityVisibility? = nil, visibilityTag: String? = nil) {
        self.attachments = attachments
        self.collectionRefs = collectionRefs
        self.createNotificationActivity = createNotificationActivity
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
        self.restrictReplies = restrictReplies
        self.searchData = searchData
        self.skipEnrichUrl = skipEnrichUrl
        self.skipPush = skipPush
        self.text = text
        self.type = type
        self.visibility = visibility
        self.visibilityTag = visibilityTag
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case attachments
        case collectionRefs = "collection_refs"
        case createNotificationActivity = "create_notification_activity"
        case custom
        case expiresAt = "expires_at"
        case feeds
        case filterTags = "filter_tags"
        case id
        case interestTags = "interest_tags"
        case location
        case mentionedUserIds = "mentioned_user_ids"
        case parentId = "parent_id"
        case pollId = "poll_id"
        case restrictReplies = "restrict_replies"
        case searchData = "search_data"
        case skipEnrichUrl = "skip_enrich_url"
        case skipPush = "skip_push"
        case text
        case type
        case visibility
        case visibilityTag = "visibility_tag"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.attachments = try container.decodeIfPresent([Attachment].self, forKey: .attachments)
        self.collectionRefs = try container.decodeIfPresent([String].self, forKey: .collectionRefs)
        self.createNotificationActivity = try container.decodeIfPresent(Bool.self, forKey: .createNotificationActivity)
        self.custom = try container.decodeIfPresent([String: RawJSON].self, forKey: .custom)
        self.expiresAt = try container.decodeIfPresent(String.self, forKey: .expiresAt)
        self.feeds = try container.decode([String].self, forKey: .feeds)
        self.filterTags = try container.decodeIfPresent([String].self, forKey: .filterTags)
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.interestTags = try container.decodeIfPresent([String].self, forKey: .interestTags)
        self.location = try container.decodeIfPresent(Location.self, forKey: .location)
        self.mentionedUserIds = try container.decodeIfPresent([String].self, forKey: .mentionedUserIds)
        self.parentId = try container.decodeIfPresent(String.self, forKey: .parentId)
        self.pollId = try container.decodeIfPresent(String.self, forKey: .pollId)
        self.restrictReplies = try container.decodeIfPresent(RestrictReplies.self, forKey: .restrictReplies)
        self.searchData = try container.decodeIfPresent([String: RawJSON].self, forKey: .searchData)
        self.skipEnrichUrl = try container.decodeIfPresent(Bool.self, forKey: .skipEnrichUrl)
        self.skipPush = try container.decodeIfPresent(Bool.self, forKey: .skipPush)
        self.text = try container.decodeIfPresent(String.self, forKey: .text)
        self.type = try container.decode(String.self, forKey: .type)
        self.visibility = try container.decodeIfPresent(ActivityVisibility.self, forKey: .visibility)
        self.visibilityTag = try container.decodeIfPresent(String.self, forKey: .visibilityTag)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(attachments, forKey: .attachments)
        try container.encodeIfPresent(collectionRefs, forKey: .collectionRefs)
        try container.encodeIfPresent(createNotificationActivity, forKey: .createNotificationActivity)
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
        try container.encodeIfPresent(restrictReplies, forKey: .restrictReplies)
        try container.encodeIfPresent(searchData, forKey: .searchData)
        try container.encodeIfPresent(skipEnrichUrl, forKey: .skipEnrichUrl)
        try container.encodeIfPresent(skipPush, forKey: .skipPush)
        try container.encodeIfPresent(text, forKey: .text)
        try container.encode(type, forKey: .type)
        try container.encodeIfPresent(visibility, forKey: .visibility)
        try container.encodeIfPresent(visibilityTag, forKey: .visibilityTag)
    }
}

extension AddActivityRequest: Hashable {
    public static func == (lhs: AddActivityRequest, rhs: AddActivityRequest) -> Bool {
        lhs.attachments == rhs.attachments &&
            lhs.collectionRefs == rhs.collectionRefs &&
            lhs.createNotificationActivity == rhs.createNotificationActivity &&
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
            lhs.restrictReplies == rhs.restrictReplies &&
            lhs.searchData == rhs.searchData &&
            lhs.skipEnrichUrl == rhs.skipEnrichUrl &&
            lhs.skipPush == rhs.skipPush &&
            lhs.text == rhs.text &&
            lhs.type == rhs.type &&
            lhs.visibility == rhs.visibility &&
            lhs.visibilityTag == rhs.visibilityTag
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(attachments)
        hasher.combine(collectionRefs)
        hasher.combine(createNotificationActivity)
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
        hasher.combine(restrictReplies)
        hasher.combine(searchData)
        hasher.combine(skipEnrichUrl)
        hasher.combine(skipPush)
        hasher.combine(text)
        hasher.combine(type)
        hasher.combine(visibility)
        hasher.combine(visibilityTag)
    }
}
