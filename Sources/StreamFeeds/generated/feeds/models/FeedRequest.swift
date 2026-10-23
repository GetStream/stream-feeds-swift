//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class FeedRequest: @unchecked Sendable, Codable, JSONEncodable {
    public enum FeedRequestVisibility: String, Sendable, Codable, CaseIterable {
        case `private`
        case `public`
        case followers
        case members
        case visible
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

    /// Custom data for the feed
    public var custom: [String: RawJSON]?
    /// Description of the feed
    public var description: String?
    /// ID of the feed group
    public var feedGroupId: String
    /// ID of the feed
    public var feedId: String
    /// Tags used for filtering feeds
    public var filterTags: [String]?
    public var location: Location?
    /// Initial members for the feed
    public var members: [FeedMemberRequest]?
    /// Name of the feed
    public var name: String?
    /// Visibility setting for the feed. One of: public, visible, followers, members, private
    public var visibility: FeedRequestVisibility?

    public init(custom: [String: RawJSON]? = nil, description: String? = nil, feedGroupId: String, feedId: String, filterTags: [String]? = nil, location: Location? = nil, members: [FeedMemberRequest]? = nil, name: String? = nil, visibility: FeedRequestVisibility? = nil) {
        self.custom = custom
        self.description = description
        self.feedGroupId = feedGroupId
        self.feedId = feedId
        self.filterTags = filterTags
        self.location = location
        self.members = members
        self.name = name
        self.visibility = visibility
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case custom
        case description
        case feedGroupId = "feed_group_id"
        case feedId = "feed_id"
        case filterTags = "filter_tags"
        case location
        case members
        case name
        case visibility
    }
}

extension FeedRequest: Hashable {
    public static func == (lhs: FeedRequest, rhs: FeedRequest) -> Bool {
        lhs.custom == rhs.custom &&
            lhs.description == rhs.description &&
            lhs.feedGroupId == rhs.feedGroupId &&
            lhs.feedId == rhs.feedId &&
            lhs.filterTags == rhs.filterTags &&
            lhs.location == rhs.location &&
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
        hasher.combine(location)
        hasher.combine(members)
        hasher.combine(name)
        hasher.combine(visibility)
    }
}
