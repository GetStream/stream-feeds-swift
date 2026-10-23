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
    /// Custom data for the activity
    public var custom: [String: RawJSON]?
    /// Time when the activity will expire
    public var expiresAt: Date?
    /// List of feeds the activity is present in
    public var feeds: [String]?
    /// Tags used for filtering the activity
    public var filterTags: [String]?
    /// Tags indicating interest categories
    public var interestTags: [String]?
    public var location: Location?
    /// Poll ID
    public var pollId: String?
    /// The text content of the activity
    public var text: String?
    /// Visibility setting for the activity
    public var visibility: UpdateActivityRequestVisibility?

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

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case attachments
        case custom
        case expiresAt = "expires_at"
        case feeds
        case filterTags = "filter_tags"
        case interestTags = "interest_tags"
        case location
        case pollId = "poll_id"
        case text
        case visibility
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
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
        var container = encoder.container(keyedBy: CodingKeys.self)
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
