import Foundation
import StreamCore

public final class FollowManyRequest: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var follows: [FollowPayload]

    public init(follows: [FollowPayload]) {
        self.follows = follows
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case follows
    }

    public static func == (lhs: FollowManyRequest, rhs: FollowManyRequest) -> Bool {
        lhs.follows == rhs.follows
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(follows)
    }
}
