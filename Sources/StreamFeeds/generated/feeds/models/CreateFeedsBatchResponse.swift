import Foundation
import StreamCore

public final class CreateFeedsBatchResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var duration: String
    public var feeds: [FeedResponse]

    public init(duration: String, feeds: [FeedResponse]) {
        self.duration = duration
        self.feeds = feeds
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case duration
        case feeds
    }

    public static func == (lhs: CreateFeedsBatchResponse, rhs: CreateFeedsBatchResponse) -> Bool {
        lhs.duration == rhs.duration &&
            lhs.feeds == rhs.feeds
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(duration)
        hasher.combine(feeds)
    }
}
