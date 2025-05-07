import Foundation
import StreamCore

public final class CreateFeedRequest: @unchecked Sendable, Codable, JSONEncodable, Hashable {
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
    public var group: String
    public var id: String
    public var members: [FeedMemberPayload]?
    public var visibility: FeedVisibility?

    public init(custom: [String: RawJSON]? = nil, group: String, id: String, members: [FeedMemberPayload]? = nil, visibility: FeedVisibility? = nil) {
        self.custom = custom
        self.group = group
        self.id = id
        self.members = members
        self.visibility = visibility
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case custom
        case group
        case id
        case members
        case visibility
    }

    public static func == (lhs: CreateFeedRequest, rhs: CreateFeedRequest) -> Bool {
        lhs.custom == rhs.custom &&
            lhs.group == rhs.group &&
            lhs.id == rhs.id &&
            lhs.members == rhs.members &&
            lhs.visibility == rhs.visibility
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(custom)
        hasher.combine(group)
        hasher.combine(id)
        hasher.combine(members)
        hasher.combine(visibility)
    }
}
