//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class ActivityRequestRestrictReplies: RawRepresentable, Codable, Hashable, Sendable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public static let everyone = ActivityRequestRestrictReplies(rawValue: "everyone")
    public static let nobody = ActivityRequestRestrictReplies(rawValue: "nobody")
    public static let peopleIFollow = ActivityRequestRestrictReplies(rawValue: "people_i_follow")
}

public final class ActivityRequestVisibility: RawRepresentable, Codable, Hashable, Sendable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public static let `private` = ActivityRequestVisibility(rawValue: "private")
    public static let `public` = ActivityRequestVisibility(rawValue: "public")
    public static let tag = ActivityRequestVisibility(rawValue: "tag")
}

public final class ActivityRequest: Sendable, Codable, JSONEncodable {
    /// List of attachments for the activity
    public let attachments: [Attachment]?
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
    public let visibility: ActivityRequestVisibility?
    /// If visibility is 'tag', this is the tag name and is required
    public let visibilityTag: String?

    public init(attachments: [Attachment]? = nil, custom: [String: RawJSON]? = nil, expiresAt: String? = nil, feeds: [String], filterTags: [String]? = nil, id: String? = nil, interestTags: [String]? = nil, location: Location? = nil, mentionedUserIds: [String]? = nil, parentId: String? = nil, pollId: String? = nil, searchData: [String: RawJSON]? = nil, text: String? = nil, type: String, visibility: ActivityRequestVisibility? = nil, visibilityTag: String? = nil) {
        self.attachments = attachments
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

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.attachments = try container.decodeIfPresent([Attachment].self, forKey: .attachments)
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
        self.searchData = try container.decodeIfPresent([String: RawJSON].self, forKey: .searchData)
        self.text = try container.decodeIfPresent(String.self, forKey: .text)
        self.type = try container.decode(String.self, forKey: .type)
        self.visibility = try container.decodeIfPresent(ActivityRequestVisibility.self, forKey: .visibility)
        self.visibilityTag = try container.decodeIfPresent(String.self, forKey: .visibilityTag)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(attachments, forKey: .attachments)
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
