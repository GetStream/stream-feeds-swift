import Foundation
import StreamCore

public final class FeedMemberRequest: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var custom: [String: RawJSON]?
    public var invite: Bool?
    public var role: String?
    public var userId: String

    public init(custom: [String: RawJSON]? = nil, invite: Bool? = nil, role: String? = nil, userId: String) {
        self.custom = custom
        self.invite = invite
        self.role = role
        self.userId = userId
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case custom
        case invite
        case role
        case userId = "user_id"
    }

    public static func == (lhs: FeedMemberRequest, rhs: FeedMemberRequest) -> Bool {
        lhs.custom == rhs.custom &&
            lhs.invite == rhs.invite &&
            lhs.role == rhs.role &&
            lhs.userId == rhs.userId
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(custom)
        hasher.combine(invite)
        hasher.combine(role)
        hasher.combine(userId)
    }
}
