import Foundation
import StreamCore

public final class FollowManyResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var duration: String
    public var follows: [Follow]

    public init(duration: String, follows: [Follow]) {
        self.duration = duration
        self.follows = follows
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case duration
        case follows
    }

    public static func == (lhs: FollowManyResponse, rhs: FollowManyResponse) -> Bool {
        lhs.duration == rhs.duration &&
            lhs.follows == rhs.follows
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(duration)
        hasher.combine(follows)
    }
}
