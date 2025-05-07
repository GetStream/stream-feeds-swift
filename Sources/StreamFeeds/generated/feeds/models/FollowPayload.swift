import Foundation
import StreamCore

public final class FollowPayload: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var custom: [String: RawJSON]?
    public var pushPreference: String?
    public var request: Bool?
    public var source: String
    public var target: String

    public init(custom: [String: RawJSON]? = nil, pushPreference: String? = nil, request: Bool? = nil, source: String, target: String) {
        self.custom = custom
        self.pushPreference = pushPreference
        self.request = request
        self.source = source
        self.target = target
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case custom
        case pushPreference = "push_preference"
        case request
        case source
        case target
    }

    public static func == (lhs: FollowPayload, rhs: FollowPayload) -> Bool {
        lhs.custom == rhs.custom &&
            lhs.pushPreference == rhs.pushPreference &&
            lhs.request == rhs.request &&
            lhs.source == rhs.source &&
            lhs.target == rhs.target
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(custom)
        hasher.combine(pushPreference)
        hasher.combine(request)
        hasher.combine(source)
        hasher.combine(target)
    }
}
