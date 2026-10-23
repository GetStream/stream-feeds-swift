//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class FeedRequestVisibility: RawRepresentable, Codable, Hashable, Sendable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public static let `private` = FeedRequestVisibility(rawValue: "private")
    public static let `public` = FeedRequestVisibility(rawValue: "public")
    public static let followers = FeedRequestVisibility(rawValue: "followers")
    public static let members = FeedRequestVisibility(rawValue: "members")
    public static let visible = FeedRequestVisibility(rawValue: "visible")
}

public final class FeedRequest: Sendable, Codable, JSONEncodable {
    /// Custom data for the feed
    public let custom: [String: RawJSON]?
    /// Description of the feed
    public let description: String?
    /// ID of the feed group
    public let feedGroupId: String
    /// ID of the feed
    public let feedId: String
    /// Tags used for filtering feeds
    public let filterTags: [String]?
    /// Initial members for the feed
    public let members: [FeedMemberRequest]?
    /// Name of the feed
    public let name: String?
    /// Visibility setting for the feed. One of: public, visible, followers, members, private
    public let visibility: FeedRequestVisibility?

    public init(custom: [String: RawJSON]? = nil, description: String? = nil, feedGroupId: String, feedId: String, filterTags: [String]? = nil, members: [FeedMemberRequest]? = nil, name: String? = nil, visibility: FeedRequestVisibility? = nil) {
        self.custom = custom
        self.description = description
        self.feedGroupId = feedGroupId
        self.feedId = feedId
        self.filterTags = filterTags
        self.members = members
        self.name = name
        self.visibility = visibility
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.custom = try container.decodeIfPresent([String: RawJSON].self, forKey: .custom)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.feedGroupId = try container.decode(String.self, forKey: .feedGroupId)
        self.feedId = try container.decode(String.self, forKey: .feedId)
        self.filterTags = try container.decodeIfPresent([String].self, forKey: .filterTags)
        self.members = try container.decodeIfPresent([FeedMemberRequest].self, forKey: .members)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.visibility = try container.decodeIfPresent(FeedRequestVisibility.self, forKey: .visibility)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(custom, forKey: .custom)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encode(feedGroupId, forKey: .feedGroupId)
        try container.encode(feedId, forKey: .feedId)
        try container.encodeIfPresent(filterTags, forKey: .filterTags)
        try container.encodeIfPresent(members, forKey: .members)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(visibility, forKey: .visibility)
    }
}

extension FeedRequest: Hashable {
    public static func == (lhs: FeedRequest, rhs: FeedRequest) -> Bool {
        lhs.custom == rhs.custom &&
            lhs.description == rhs.description &&
            lhs.feedGroupId == rhs.feedGroupId &&
            lhs.feedId == rhs.feedId &&
            lhs.filterTags == rhs.filterTags &&
            lhs.members == rhs.members &&
            lhs.name == rhs.name &&
            lhs.visibility == rhs.visibility
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(custom)
        hasher.combine(description)
        hasher.combine(feedGroupId)
        hasher.combine(feedId)
        hasher.combine(filterTags)
        hasher.combine(members)
        hasher.combine(name)
        hasher.combine(visibility)
    }
}
