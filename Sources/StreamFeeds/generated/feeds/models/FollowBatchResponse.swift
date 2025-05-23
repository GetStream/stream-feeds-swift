import Foundation
import StreamCore

public final class FollowBatchResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var duration: String
    public var follows: [FollowResponse]

    public init(duration: String, follows: [FollowResponse]) {
        self.duration = duration
        self.follows = follows
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case duration
        case follows
    }

    public static func == (lhs: FollowBatchResponse, rhs: FollowBatchResponse) -> Bool {
        lhs.duration == rhs.duration &&
            lhs.follows == rhs.follows
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(duration)
        hasher.combine(follows)
    }
}
