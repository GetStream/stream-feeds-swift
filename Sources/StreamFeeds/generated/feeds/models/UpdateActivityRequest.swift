//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UpdateActivityRequest: @unchecked Sendable, Codable, JSONEncodable {
    public enum UpdateActivityRequestRestrictReplies: String, Sendable, Codable, CaseIterable {
        case everyone
        case nobody
        case peopleIFollow = "people_i_follow"
        case unknown = "_unknown"

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let decodedValue = try? container.decode(String.self),
               let value = Self(rawValue: decodedValue) {
                self = value
            } else {
                self = .unknown
            }
        }
    }
    
    public enum UpdateActivityRequestVisibility: String, Sendable, Codable, CaseIterable {
        case `private`
        case `public`
        case tag
        case unknown = "_unknown"

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let decodedValue = try? container.decode(String.self),
               let value = Self(rawValue: decodedValue) {
                self = value
            } else {
                self = .unknown
            }
        }
    }

    /// List of attachments for the activity
    public var attachments: [Attachment]?
    /// Collections that this activity references
    public var collectionRefs: [String]?
    /// Whether to copy custom data to the notification activity (only applies when handle_mention_notifications creates notifications) Deprecated: use notification_context.trigger.custom and notification_context.target.custom instead
    @available(*, deprecated, message: "use notification_context.trigger.custom and notification_context.target.custom instead")
    public var copyCustomToNotification: Bool? { get { _copyCustomToNotification } set { _copyCustomToNotification = newValue } }
    private var _copyCustomToNotification: Bool?
    /// Custom data for the activity
    public var custom: [String: RawJSON]?
    /// If true, enriches the activity's current_feed with own_* fields (own_follows, own_followings, own_capabilities, own_membership). Defaults to false for performance.
    public var enrichOwnFields: Bool?
    /// Time when the activity will expire
    public var expiresAt: Date?
    /// List of feeds the activity is present in
    public var feeds: [String]?
    /// Tags used for filtering the activity
    public var filterTags: [String]?
    /// If true, creates notification activities for newly mentioned users and deletes notifications for users no longer mentioned
    public var handleMentionNotifications: Bool?
    /// Tags indicating interest categories
    public var interestTags: [String]?
    public var location: Location?
    /// List of user IDs mentioned in the activity
    public var mentionedUserIds: [String]?
    /// Poll ID
    public var pollId: String?
    /// Controls who can add comments/replies to this activity. One of: everyone, people_i_follow, nobody
    public var restrictReplies: UpdateActivityRequestRestrictReplies?
    /// If true, runs activity processors on the updated activity. Processors will only run if the activity text and/or attachments are changed. Defaults to false.
    public var runActivityProcessors: Bool?
    /// Additional data for search indexing
    public var searchData: [String: RawJSON]?
    /// Whether to skip URL enrichment for the activity
    public var skipEnrichUrl: Bool?
    /// The text content of the activity
    public var text: String?
    /// Visibility setting for the activity
    public var visibility: UpdateActivityRequestVisibility?
    /// If visibility is 'tag', this is the tag name and is required
    public var visibilityTag: String?

    public init(attachments: [Attachment]? = nil, collectionRefs: [String]? = nil, copyCustomToNotification: Bool? = nil, custom: [String: RawJSON]? = nil, enrichOwnFields: Bool? = nil, expiresAt: Date? = nil, feeds: [String]? = nil, filterTags: [String]? = nil, handleMentionNotifications: Bool? = nil, interestTags: [String]? = nil, location: Location? = nil, mentionedUserIds: [String]? = nil, pollId: String? = nil, restrictReplies: UpdateActivityRequestRestrictReplies? = nil, runActivityProcessors: Bool? = nil, searchData: [String: RawJSON]? = nil, skipEnrichUrl: Bool? = nil, text: String? = nil, visibility: UpdateActivityRequestVisibility? = nil, visibilityTag: String? = nil) {
        self.attachments = attachments
        self.collectionRefs = collectionRefs
        self._copyCustomToNotification = copyCustomToNotification
        self.custom = custom
        self.enrichOwnFields = enrichOwnFields
        self.expiresAt = expiresAt
        self.feeds = feeds
        self.filterTags = filterTags
        self.handleMentionNotifications = handleMentionNotifications
        self.interestTags = interestTags
        self.location = location
        self.mentionedUserIds = mentionedUserIds
        self.pollId = pollId
        self.restrictReplies = restrictReplies
        self.runActivityProcessors = runActivityProcessors
        self.searchData = searchData
        self.skipEnrichUrl = skipEnrichUrl
        self.text = text
        self.visibility = visibility
        self.visibilityTag = visibilityTag
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case attachments
        case collectionRefs = "collection_refs"
        case copyCustomToNotification = "copy_custom_to_notification"
        case custom
        case enrichOwnFields = "enrich_own_fields"
        case expiresAt = "expires_at"
        case feeds
        case filterTags = "filter_tags"
        case handleMentionNotifications = "handle_mention_notifications"
        case interestTags = "interest_tags"
        case location
        case mentionedUserIds = "mentioned_user_ids"
        case pollId = "poll_id"
        case restrictReplies = "restrict_replies"
        case runActivityProcessors = "run_activity_processors"
        case searchData = "search_data"
        case skipEnrichUrl = "skip_enrich_url"
        case text
        case visibility
        case visibilityTag = "visibility_tag"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.attachments = try container.decodeIfPresent([Attachment].self, forKey: .attachments)
        self.collectionRefs = try container.decodeIfPresent([String].self, forKey: .collectionRefs)
        self._copyCustomToNotification = try container.decodeIfPresent(Bool.self, forKey: .copyCustomToNotification)
        self.custom = try container.decodeIfPresent([String: RawJSON].self, forKey: .custom)
        self.enrichOwnFields = try container.decodeIfPresent(Bool.self, forKey: .enrichOwnFields)
        self.expiresAt = try container.decodeIfPresent(Date.self, forKey: .expiresAt)
        self.feeds = try container.decodeIfPresent([String].self, forKey: .feeds)
        self.filterTags = try container.decodeIfPresent([String].self, forKey: .filterTags)
        self.handleMentionNotifications = try container.decodeIfPresent(Bool.self, forKey: .handleMentionNotifications)
        self.interestTags = try container.decodeIfPresent([String].self, forKey: .interestTags)
        self.location = try container.decodeIfPresent(Location.self, forKey: .location)
        self.mentionedUserIds = try container.decodeIfPresent([String].self, forKey: .mentionedUserIds)
        self.pollId = try container.decodeIfPresent(String.self, forKey: .pollId)
        self.restrictReplies = try container.decodeIfPresent(UpdateActivityRequestRestrictReplies.self, forKey: .restrictReplies)
        self.runActivityProcessors = try container.decodeIfPresent(Bool.self, forKey: .runActivityProcessors)
        self.searchData = try container.decodeIfPresent([String: RawJSON].self, forKey: .searchData)
        self.skipEnrichUrl = try container.decodeIfPresent(Bool.self, forKey: .skipEnrichUrl)
        self.text = try container.decodeIfPresent(String.self, forKey: .text)
        self.visibility = try container.decodeIfPresent(UpdateActivityRequestVisibility.self, forKey: .visibility)
        self.visibilityTag = try container.decodeIfPresent(String.self, forKey: .visibilityTag)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(attachments, forKey: .attachments)
        try container.encodeIfPresent(collectionRefs, forKey: .collectionRefs)
        try container.encodeIfPresent(_copyCustomToNotification, forKey: .copyCustomToNotification)
        try container.encodeIfPresent(custom, forKey: .custom)
        try container.encodeIfPresent(enrichOwnFields, forKey: .enrichOwnFields)
        try container.encodeIfPresent(expiresAt, forKey: .expiresAt)
        try container.encodeIfPresent(feeds, forKey: .feeds)
        try container.encodeIfPresent(filterTags, forKey: .filterTags)
        try container.encodeIfPresent(handleMentionNotifications, forKey: .handleMentionNotifications)
        try container.encodeIfPresent(interestTags, forKey: .interestTags)
        try container.encodeIfPresent(location, forKey: .location)
        try container.encodeIfPresent(mentionedUserIds, forKey: .mentionedUserIds)
        try container.encodeIfPresent(pollId, forKey: .pollId)
        try container.encodeIfPresent(restrictReplies, forKey: .restrictReplies)
        try container.encodeIfPresent(runActivityProcessors, forKey: .runActivityProcessors)
        try container.encodeIfPresent(searchData, forKey: .searchData)
        try container.encodeIfPresent(skipEnrichUrl, forKey: .skipEnrichUrl)
        try container.encodeIfPresent(text, forKey: .text)
        try container.encodeIfPresent(visibility, forKey: .visibility)
        try container.encodeIfPresent(visibilityTag, forKey: .visibilityTag)
    }
}

extension UpdateActivityRequest: Hashable {
    public static func == (lhs: UpdateActivityRequest, rhs: UpdateActivityRequest) -> Bool {
        lhs.attachments == rhs.attachments &&
            lhs.collectionRefs == rhs.collectionRefs &&
            lhs._copyCustomToNotification == rhs._copyCustomToNotification &&
            lhs.custom == rhs.custom &&
            lhs.enrichOwnFields == rhs.enrichOwnFields &&
            lhs.expiresAt == rhs.expiresAt &&
            lhs.feeds == rhs.feeds &&
            lhs.filterTags == rhs.filterTags &&
            lhs.handleMentionNotifications == rhs.handleMentionNotifications &&
            lhs.interestTags == rhs.interestTags &&
            lhs.location == rhs.location &&
            lhs.mentionedUserIds == rhs.mentionedUserIds &&
            lhs.pollId == rhs.pollId &&
            lhs.restrictReplies == rhs.restrictReplies &&
            lhs.runActivityProcessors == rhs.runActivityProcessors &&
            lhs.searchData == rhs.searchData &&
            lhs.skipEnrichUrl == rhs.skipEnrichUrl &&
            lhs.text == rhs.text &&
            lhs.visibility == rhs.visibility &&
            lhs.visibilityTag == rhs.visibilityTag
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(attachments)
        hasher.combine(collectionRefs)
        hasher.combine(_copyCustomToNotification)
        hasher.combine(custom)
        hasher.combine(enrichOwnFields)
        hasher.combine(expiresAt)
        hasher.combine(feeds)
        hasher.combine(filterTags)
        hasher.combine(handleMentionNotifications)
        hasher.combine(interestTags)
        hasher.combine(location)
        hasher.combine(mentionedUserIds)
        hasher.combine(pollId)
        hasher.combine(restrictReplies)
        hasher.combine(runActivityProcessors)
        hasher.combine(searchData)
        hasher.combine(skipEnrichUrl)
        hasher.combine(text)
        hasher.combine(visibility)
        hasher.combine(visibilityTag)
    }
}
