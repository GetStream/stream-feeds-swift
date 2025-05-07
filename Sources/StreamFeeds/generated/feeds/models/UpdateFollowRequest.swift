import Foundation
import StreamCore

public final class UpdateFollowRequest: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var custom: [String: RawJSON]?
    public var pushPreference: String?

    public init(custom: [String: RawJSON]? = nil, pushPreference: String? = nil) {
        self.custom = custom
        self.pushPreference = pushPreference
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case custom
        case pushPreference = "push_preference"
    }

    public static func == (lhs: UpdateFollowRequest, rhs: UpdateFollowRequest) -> Bool {
        lhs.custom == rhs.custom &&
            lhs.pushPreference == rhs.pushPreference
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(custom)
        hasher.combine(pushPreference)
    }
}
