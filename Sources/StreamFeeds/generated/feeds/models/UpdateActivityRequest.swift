//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UpdateActivityRequestRestrictReplies: RawRepresentable, Codable, Hashable, Sendable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public static let everyone = UpdateActivityRequestRestrictReplies(rawValue: "everyone")
    public static let nobody = UpdateActivityRequestRestrictReplies(rawValue: "nobody")
    public static let peopleIFollow = UpdateActivityRequestRestrictReplies(rawValue: "people_i_follow")
}

public final class UpdateActivityRequestVisibility: RawRepresentable, Codable, Hashable, Sendable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public static let `private` = UpdateActivityRequestVisibility(rawValue: "private")
    public static let `public` = UpdateActivityRequestVisibility(rawValue: "public")
    public static let tag = UpdateActivityRequestVisibility(rawValue: "tag")
}

public final class UpdateActivityRequest: Sendable, Codable, JSONEncodable {
    /// List of attachments for the activity
    public let attachments: [Attachment]?
    /// Collections that this activity references
    public let collectionRefs: [String]?
    /// Whether to copy custom data to the notification activity (only applies when handle_mention_notifications creates notifications) Deprecated: use notification_context.trigger.custom and notification_context.target.custom instead
    @available(*, deprecated, message: "use notification_context.trigger.custom and notification_context.target.custom instead")
    public var copyCustomToNotification: Bool? { _copyCustomToNotification }
    private let _copyCustomToNotification: Bool?
    /// Custom data for the activity
    public let custom: [String: RawJSON]?
    /// If true, enriches the activity's current_feed with own_* fields (own_follows, own_followings, own_capabilities, own_membership). Defaults to false for performance.
    public let enrichOwnFields: Bool?
    /// Time when the activity will expire
    public let expiresAt: Date?
    /// List of feeds the activity is present in
    public let feeds: [String]?
    /// Tags used for filtering the activity
    public let filterTags: [String]?
    /// If true, creates notification activities for newly mentioned users and deletes notifications for users no longer mentioned
    public let handleMentionNotifications: Bool?
    /// Tags indicating interest categories
    public let interestTags: [String]?
    public let location: Location?
    /// List of user IDs mentioned in the activity
    public let mentionedUserIds: [String]?
    /// Poll ID
    public let pollId: String?
    /// Controls who can add comments/replies to this activity. One of: everyone, people_i_follow, nobody
    public let restrictReplies: UpdateActivityRequestRestrictReplies?
    /// If true, runs activity processors on the updated activity. Processors will only run if the activity text and/or attachments are changed. Defaults to false.
    public let runActivityProcessors: Bool?
    /// Additional data for search indexing
    public let searchData: [String: RawJSON]?
    /// Whether to skip URL enrichment for the activity
    public let skipEnrichUrl: Bool?
    /// The text content of the activity
    public let text: String?
    /// Visibility setting for the activity
    public let visibility: UpdateActivityRequestVisibility?
    /// If visibility is 'tag', this is the tag name and is required
    public let visibilityTag: String?

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

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
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
        var container = encoder.container(keyedBy: StringCodingKey.self)
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
