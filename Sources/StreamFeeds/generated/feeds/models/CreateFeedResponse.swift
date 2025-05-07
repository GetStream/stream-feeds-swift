import Foundation
import StreamCore

public final class CreateFeedResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var duration: String
    public var feed: Feed
    public var members: [FeedMember]?

    public init(duration: String, feed: Feed, members: [FeedMember]? = nil) {
        self.duration = duration
        self.feed = feed
        self.members = members
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case duration
        case feed
        case members
    }

    public static func == (lhs: CreateFeedResponse, rhs: CreateFeedResponse) -> Bool {
        lhs.duration == rhs.duration &&
            lhs.feed == rhs.feed &&
            lhs.members == rhs.members
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(duration)
        hasher.combine(feed)
        hasher.combine(members)
    }
}
