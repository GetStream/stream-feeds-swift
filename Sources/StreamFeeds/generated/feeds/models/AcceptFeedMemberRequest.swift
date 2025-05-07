import Foundation
import StreamCore

public final class AcceptFeedMemberRequest: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var feed: String
    public var userId: String

    public init(feed: String, userId: String) {
        self.feed = feed
        self.userId = userId
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case feed
        case userId = "user_id"
    }

    public static func == (lhs: AcceptFeedMemberRequest, rhs: AcceptFeedMemberRequest) -> Bool {
        lhs.feed == rhs.feed &&
            lhs.userId == rhs.userId
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(feed)
        hasher.combine(userId)
    }
}
