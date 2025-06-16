import Foundation
import StreamCore

public final class FeedRequest: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var createdById: String?
    public var custom: [String: RawJSON]?
    public var description: String?
    public var feedGroupId: String
    public var feedId: String
    public var members: [FeedMemberRequest]?
    public var name: String?
    public var visibility: String?

    public init(createdById: String? = nil, custom: [String: RawJSON]? = nil, description: String? = nil, feedGroupId: String, feedId: String, members: [FeedMemberRequest]? = nil, name: String? = nil, visibility: String? = nil) {
        self.createdById = createdById
        self.custom = custom
        self.description = description
        self.feedGroupId = feedGroupId
        self.feedId = feedId
        self.members = members
        self.name = name
        self.visibility = visibility
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case createdById = "created_by_id"
        case custom
        case description
        case feedGroupId = "feed_group_id"
        case feedId = "feed_id"
        case members
        case name
        case visibility
    }

    public static func == (lhs: FeedRequest, rhs: FeedRequest) -> Bool {
        lhs.createdById == rhs.createdById &&
            lhs.custom == rhs.custom &&
            lhs.description == rhs.description &&
            lhs.feedGroupId == rhs.feedGroupId &&
            lhs.feedId == rhs.feedId &&
            lhs.members == rhs.members &&
            lhs.name == rhs.name &&
            lhs.visibility == rhs.visibility
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(createdById)
        hasher.combine(custom)
        hasher.combine(description)
        hasher.combine(feedGroupId)
        hasher.combine(feedId)
        hasher.combine(members)
        hasher.combine(name)
        hasher.combine(visibility)
    }
}
