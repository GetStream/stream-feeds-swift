import Foundation
import StreamCore

public final class AcceptFollowResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var duration: String
    public var follow: FollowResponse

    public init(duration: String, follow: FollowResponse) {
        self.duration = duration
        self.follow = follow
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case duration
        case follow
    }

    public static func == (lhs: AcceptFollowResponse, rhs: AcceptFollowResponse) -> Bool {
        lhs.duration == rhs.duration &&
            lhs.follow == rhs.follow
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(duration)
        hasher.combine(follow)
    }
}
