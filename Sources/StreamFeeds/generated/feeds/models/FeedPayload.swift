import Foundation
import StreamCore

public final class FeedPayload: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public enum string: String, Sendable, Codable, CaseIterable {
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
    public var groupId: String
    public var id: String
    public var members: [FeedMemberPayload]?
    public var ownerId: String?
    public var visibility: String?

    public init(custom: [String: RawJSON]? = nil, groupId: String, id: String, members: [FeedMemberPayload]? = nil, ownerId: String? = nil, visibility: String? = nil) {
        self.custom = custom
        self.groupId = groupId
        self.id = id
        self.members = members
        self.ownerId = ownerId
        self.visibility = visibility
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case custom
        case groupId = "group_id"
        case id
        case members
        case ownerId = "owner_id"
        case visibility
    }

    public static func == (lhs: FeedPayload, rhs: FeedPayload) -> Bool {
        lhs.custom == rhs.custom &&
            lhs.groupId == rhs.groupId &&
            lhs.id == rhs.id &&
            lhs.members == rhs.members &&
            lhs.ownerId == rhs.ownerId &&
            lhs.visibility == rhs.visibility
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(custom)
        hasher.combine(groupId)
        hasher.combine(id)
        hasher.combine(members)
        hasher.combine(ownerId)
        hasher.combine(visibility)
    }
}
