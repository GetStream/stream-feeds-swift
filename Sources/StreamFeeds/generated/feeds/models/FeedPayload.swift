import Foundation
import StreamCore

public final class FeedPayload: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public enum FeedVisibility: String, Sendable, Codable, CaseIterable {
        case followers
        case `private` = "private"
        case `public` = "public"
        case restricted = "restricted"
        case visible = "visible"
        case unknown = "_unknown"

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let decodedValue = try? container.decode(String.self),
               let value = Self(rawValue: decodedValue)
            {
                self = value
            } else {
                self = .unknown
            }
        }
    }

    public var custom: [String: RawJSON]?
    public var feedGroupId: String
    public var feedId: String
    public var members: [FeedMemberPayload]?
    public var ownerId: String?
    public var visibility: FeedVisibility?

    public init(custom: [String: RawJSON]? = nil, feedGroupId: String, feedId: String, members: [FeedMemberPayload]? = nil, ownerId: String? = nil, visibility: FeedVisibility? = nil) {
        self.custom = custom
        self.feedGroupId = feedGroupId
        self.feedId = feedId
        self.members = members
        self.ownerId = ownerId
        self.visibility = visibility
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case custom
        case feedGroupId = "feed_group_id"
        case feedId = "feed_id"
        case members
        case ownerId = "owner_id"
        case visibility
    }

    public static func == (lhs: FeedPayload, rhs: FeedPayload) -> Bool {
        lhs.custom == rhs.custom &&
            lhs.feedGroupId == rhs.feedGroupId &&
            lhs.feedId == rhs.feedId &&
            lhs.members == rhs.members &&
            lhs.ownerId == rhs.ownerId &&
            lhs.visibility == rhs.visibility
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(custom)
        hasher.combine(feedGroupId)
        hasher.combine(feedId)
        hasher.combine(members)
        hasher.combine(ownerId)
        hasher.combine(visibility)
    }
}
