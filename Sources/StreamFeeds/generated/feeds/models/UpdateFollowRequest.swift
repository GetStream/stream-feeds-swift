import Foundation
import StreamCore

public final class UpdateFollowRequest: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var custom: [String: RawJSON]?
    public var followerRole: String?
    public var pushPreference: String?
    public var source: String
    public var target: String

    public init(custom: [String: RawJSON]? = nil, followerRole: String? = nil, pushPreference: String? = nil, source: String, target: String) {
        self.custom = custom
        self.followerRole = followerRole
        self.pushPreference = pushPreference
        self.source = source
        self.target = target
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case custom
        case followerRole = "follower_role"
        case pushPreference = "push_preference"
        case source
        case target
    }

    public static func == (lhs: UpdateFollowRequest, rhs: UpdateFollowRequest) -> Bool {
        lhs.custom == rhs.custom &&
            lhs.followerRole == rhs.followerRole &&
            lhs.pushPreference == rhs.pushPreference &&
            lhs.source == rhs.source &&
            lhs.target == rhs.target
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(custom)
        hasher.combine(followerRole)
        hasher.combine(pushPreference)
        hasher.combine(source)
        hasher.combine(target)
    }
}
