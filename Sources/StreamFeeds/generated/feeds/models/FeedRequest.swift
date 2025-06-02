import Foundation
import StreamCore

public final class FeedRequest: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public enum FeedVisibility: String, Sendable, Codable, CaseIterable {
        case followers
        case members
        case `private` = "private"
        case `public` = "public"
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

    public var createdById: String?
    public var custom: [String: RawJSON]?
    public var feedGroupId: String
    public var feedId: String
    public var members: [FeedMemberRequest]?
    public var visibility: FeedVisibility?

    public init(createdById: String? = nil, custom: [String: RawJSON]? = nil, feedGroupId: String, feedId: String, members: [FeedMemberRequest]? = nil, visibility: FeedVisibility? = nil) {
        self.createdById = createdById
        self.custom = custom
        self.feedGroupId = feedGroupId
        self.feedId = feedId
        self.members = members
        self.visibility = visibility
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case createdById = "created_by_id"
        case custom
        case feedGroupId = "feed_group_id"
        case feedId = "feed_id"
        case members
        case visibility
    }

    public static func == (lhs: FeedRequest, rhs: FeedRequest) -> Bool {
        lhs.createdById == rhs.createdById &&
            lhs.custom == rhs.custom &&
            lhs.feedGroupId == rhs.feedGroupId &&
            lhs.feedId == rhs.feedId &&
            lhs.members == rhs.members &&
            lhs.visibility == rhs.visibility
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(createdById)
        hasher.combine(custom)
        hasher.combine(feedGroupId)
        hasher.combine(feedId)
        hasher.combine(members)
        hasher.combine(visibility)
    }
}
