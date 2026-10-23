//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class AddActivityRequestRestrictReplies: RawRepresentable, Codable, Hashable, Sendable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public static let everyone = AddActivityRequestRestrictReplies(rawValue: "everyone")
    public static let nobody = AddActivityRequestRestrictReplies(rawValue: "nobody")
    public static let peopleIFollow = AddActivityRequestRestrictReplies(rawValue: "people_i_follow")
}

public final class AddActivityRequestVisibility: RawRepresentable, Codable, Hashable, Sendable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public static let `private` = AddActivityRequestVisibility(rawValue: "private")
    public static let `public` = AddActivityRequestVisibility(rawValue: "public")
    public static let tag = AddActivityRequestVisibility(rawValue: "tag")
}

public final class AddActivityRequest: Sendable, Codable, JSONEncodable {
    /// List of attachments for the activity
    public let attachments: [Attachment]?
    /// Collections that this activity references
    public let collectionRefs: [String]?
    /// Collections to create or update as part of this request, so an activity and the collections it references can be written in one call. Their refs (name:id) are added to collection_refs automatically; you do not need to restate them, and they count toward the same per-activity collection-reference limit, which is the effective cap here. A collection that already exists has its custom data updated. Use collection_refs instead when the collection already exists and you are only referencing it, which requires no collection permissions.
    public let collections: [CollectionRequest]?
    /// Whether to copy custom data to the notification activity (only applies when create_notification_activity is true) Deprecated: use notification_context.trigger.custom and notification_context.target.custom instead
    @available(*, deprecated, message: "use notification_context.trigger.custom and notification_context.target.custom instead")
    public var copyCustomToNotification: Bool? { _copyCustomToNotification }
    private let _copyCustomToNotification: Bool?
    /// Whether to create notification activities for mentioned users
    public let createNotificationActivity: Bool?
    /// Custom data for the activity
    public let custom: [String: RawJSON]?
    public let enrichOwnFields: Bool?
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
    /// Controls who can add comments/replies to this activity. One of: everyone, people_i_follow, nobody
    public let restrictReplies: AddActivityRequestRestrictReplies?
    /// Additional data for search indexing
    public let searchData: [String: RawJSON]?
    /// Whether to skip URL enrichment for the activity
    public let skipEnrichUrl: Bool?
    /// Whether to skip push notifications
    public let skipPush: Bool?
    /// Text content of the activity
    public let text: String?
    /// Type of activity
    public let type: String
    /// Visibility setting for the activity. One of: public, private, tag
    public let visibility: AddActivityRequestVisibility?
    /// If visibility is 'tag', this is the tag name and is required
    public let visibilityTag: String?

    public init(attachments: [Attachment]? = nil, collectionRefs: [String]? = nil, collections: [CollectionRequest]? = nil, copyCustomToNotification: Bool? = nil, createNotificationActivity: Bool? = nil, custom: [String: RawJSON]? = nil, enrichOwnFields: Bool? = nil, expiresAt: String? = nil, feeds: [String], filterTags: [String]? = nil, id: String? = nil, interestTags: [String]? = nil, location: Location? = nil, mentionedUserIds: [String]? = nil, parentId: String? = nil, pollId: String? = nil, restrictReplies: AddActivityRequestRestrictReplies? = nil, searchData: [String: RawJSON]? = nil, skipEnrichUrl: Bool? = nil, skipPush: Bool? = nil, text: String? = nil, type: String, visibility: AddActivityRequestVisibility? = nil, visibilityTag: String? = nil) {
        self.attachments = attachments
        self.collectionRefs = collectionRefs
        self.collections = collections
        self._copyCustomToNotification = copyCustomToNotification
        self.createNotificationActivity = createNotificationActivity
        self.custom = custom
        self.enrichOwnFields = enrichOwnFields
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

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.attachments = try container.decodeIfPresent([Attachment].self, forKey: .attachments)
        self.collectionRefs = try container.decodeIfPresent([String].self, forKey: .collectionRefs)
        self.collections = try container.decodeIfPresent([CollectionRequest].self, forKey: .collections)
        self._copyCustomToNotification = try container.decodeIfPresent(Bool.self, forKey: .copyCustomToNotification)
        self.createNotificationActivity = try container.decodeIfPresent(Bool.self, forKey: .createNotificationActivity)
        self.custom = try container.decodeIfPresent([String: RawJSON].self, forKey: .custom)
        self.enrichOwnFields = try container.decodeIfPresent(Bool.self, forKey: .enrichOwnFields)
        self.expiresAt = try container.decodeIfPresent(String.self, forKey: .expiresAt)
        self.feeds = try container.decode([String].self, forKey: .feeds)
        self.filterTags = try container.decodeIfPresent([String].self, forKey: .filterTags)
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.interestTags = try container.decodeIfPresent([String].self, forKey: .interestTags)
        self.location = try container.decodeIfPresent(Location.self, forKey: .location)
        self.mentionedUserIds = try container.decodeIfPresent([String].self, forKey: .mentionedUserIds)
        self.parentId = try container.decodeIfPresent(String.self, forKey: .parentId)
        self.pollId = try container.decodeIfPresent(String.self, forKey: .pollId)
        self.restrictReplies = try container.decodeIfPresent(AddActivityRequestRestrictReplies.self, forKey: .restrictReplies)
        self.searchData = try container.decodeIfPresent([String: RawJSON].self, forKey: .searchData)
        self.skipEnrichUrl = try container.decodeIfPresent(Bool.self, forKey: .skipEnrichUrl)
        self.skipPush = try container.decodeIfPresent(Bool.self, forKey: .skipPush)
        self.text = try container.decodeIfPresent(String.self, forKey: .text)
        self.type = try container.decode(String.self, forKey: .type)
        self.visibility = try container.decodeIfPresent(AddActivityRequestVisibility.self, forKey: .visibility)
        self.visibilityTag = try container.decodeIfPresent(String.self, forKey: .visibilityTag)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(attachments, forKey: .attachments)
        try container.encodeIfPresent(collectionRefs, forKey: .collectionRefs)
        try container.encodeIfPresent(collections, forKey: .collections)
        try container.encodeIfPresent(_copyCustomToNotification, forKey: .copyCustomToNotification)
        try container.encodeIfPresent(createNotificationActivity, forKey: .createNotificationActivity)
        try container.encodeIfPresent(custom, forKey: .custom)
        try container.encodeIfPresent(enrichOwnFields, forKey: .enrichOwnFields)
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
            lhs.collections == rhs.collections &&
            lhs._copyCustomToNotification == rhs._copyCustomToNotification &&
            lhs.createNotificationActivity == rhs.createNotificationActivity &&
            lhs.custom == rhs.custom &&
            lhs.enrichOwnFields == rhs.enrichOwnFields &&
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
        hasher.combine(collections)
        hasher.combine(_copyCustomToNotification)
        hasher.combine(createNotificationActivity)
        hasher.combine(custom)
        hasher.combine(enrichOwnFields)
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
