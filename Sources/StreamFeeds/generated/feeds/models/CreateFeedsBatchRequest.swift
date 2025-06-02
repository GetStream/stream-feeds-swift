import Foundation
import StreamCore

public final class CreateFeedsBatchRequest: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var feeds: [FeedRequest]

    public init(feeds: [FeedRequest]) {
        self.feeds = feeds
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case feeds
    }

    public static func == (lhs: CreateFeedsBatchRequest, rhs: CreateFeedsBatchRequest) -> Bool {
        lhs.feeds == rhs.feeds
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(feeds)
    }
}
