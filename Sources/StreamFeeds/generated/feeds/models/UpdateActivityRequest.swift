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
    /// Custom data for the activity
    public let custom: [String: RawJSON]?
    /// Time when the activity will expire
    public let expiresAt: Date?
    /// List of feeds the activity is present in
    public let feeds: [String]?
    /// Tags used for filtering the activity
    public let filterTags: [String]?
    /// Tags indicating interest categories
    public let interestTags: [String]?
    public let location: Location?
    /// Poll ID
    public let pollId: String?
    /// The text content of the activity
    public let text: String?
    /// Visibility setting for the activity
    public let visibility: UpdateActivityRequestVisibility?

    public init(attachments: [Attachment]? = nil, custom: [String: RawJSON]? = nil, expiresAt: Date? = nil, feeds: [String]? = nil, filterTags: [String]? = nil, interestTags: [String]? = nil, location: Location? = nil, pollId: String? = nil, text: String? = nil, visibility: UpdateActivityRequestVisibility? = nil) {
        self.attachments = attachments
        self.custom = custom
        self.expiresAt = expiresAt
        self.feeds = feeds
        self.filterTags = filterTags
        self.interestTags = interestTags
        self.location = location
        self.pollId = pollId
        self.text = text
        self.visibility = visibility
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.attachments = try container.decodeIfPresent([Attachment].self, forKey: .attachments)
        self.custom = try container.decodeIfPresent([String: RawJSON].self, forKey: .custom)
        self.expiresAt = try container.decodeIfPresent(Date.self, forKey: .expiresAt)
        self.feeds = try container.decodeIfPresent([String].self, forKey: .feeds)
        self.filterTags = try container.decodeIfPresent([String].self, forKey: .filterTags)
        self.interestTags = try container.decodeIfPresent([String].self, forKey: .interestTags)
        self.location = try container.decodeIfPresent(Location.self, forKey: .location)
        self.pollId = try container.decodeIfPresent(String.self, forKey: .pollId)
        self.text = try container.decodeIfPresent(String.self, forKey: .text)
        self.visibility = try container.decodeIfPresent(UpdateActivityRequestVisibility.self, forKey: .visibility)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(attachments, forKey: .attachments)
        try container.encodeIfPresent(custom, forKey: .custom)
        try container.encodeIfPresent(expiresAt, forKey: .expiresAt)
        try container.encodeIfPresent(feeds, forKey: .feeds)
        try container.encodeIfPresent(filterTags, forKey: .filterTags)
        try container.encodeIfPresent(interestTags, forKey: .interestTags)
        try container.encodeIfPresent(location, forKey: .location)
        try container.encodeIfPresent(pollId, forKey: .pollId)
        try container.encodeIfPresent(text, forKey: .text)
        try container.encodeIfPresent(visibility, forKey: .visibility)
    }
}

extension UpdateActivityRequest: Hashable {
    public static func == (lhs: UpdateActivityRequest, rhs: UpdateActivityRequest) -> Bool {
        lhs.attachments == rhs.attachments &&
            lhs.custom == rhs.custom &&
            lhs.expiresAt == rhs.expiresAt &&
            lhs.feeds == rhs.feeds &&
            lhs.filterTags == rhs.filterTags &&
            lhs.interestTags == rhs.interestTags &&
            lhs.location == rhs.location &&
            lhs.pollId == rhs.pollId &&
            lhs.text == rhs.text &&
            lhs.visibility == rhs.visibility
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(attachments)
        hasher.combine(custom)
        hasher.combine(expiresAt)
        hasher.combine(feeds)
        hasher.combine(filterTags)
        hasher.combine(interestTags)
        hasher.combine(location)
        hasher.combine(pollId)
        hasher.combine(text)
        hasher.combine(visibility)
    }
}
