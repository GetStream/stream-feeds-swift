import Foundation
import StreamCore

public final class FeedMemberPayload: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var custom: [String: RawJSON]?
    public var request: Bool?
    public var role: String?
    public var userId: String

    public init(custom: [String: RawJSON]? = nil, request: Bool? = nil, role: String? = nil, userId: String) {
        self.custom = custom
        self.request = request
        self.role = role
        self.userId = userId
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case custom
        case request
        case role
        case userId = "user_id"
    }

    public static func == (lhs: FeedMemberPayload, rhs: FeedMemberPayload) -> Bool {
        lhs.custom == rhs.custom &&
            lhs.request == rhs.request &&
            lhs.role == rhs.role &&
            lhs.userId == rhs.userId
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(custom)
        hasher.combine(request)
        hasher.combine(role)
        hasher.combine(userId)
    }
}
