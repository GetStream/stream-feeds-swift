import Foundation
import StreamCore

public final class AcceptFeedMemberResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var duration: String
    public var feedMember: FeedMember

    public init(duration: String, feedMember: FeedMember) {
        self.duration = duration
        self.feedMember = feedMember
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case duration
        case feedMember = "feed_member"
    }

    public static func == (lhs: AcceptFeedMemberResponse, rhs: AcceptFeedMemberResponse) -> Bool {
        lhs.duration == rhs.duration &&
            lhs.feedMember == rhs.feedMember
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(duration)
        hasher.combine(feedMember)
    }
}
