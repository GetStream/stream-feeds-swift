import Foundation
import StreamCore

public final class QueryFeedsResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var duration: String
    public var feeds: [FeedResponse]
    public var next: String?
    public var prev: String?

    public init(duration: String, feeds: [FeedResponse], next: String? = nil, prev: String? = nil) {
        self.duration = duration
        self.feeds = feeds
        self.next = next
        self.prev = prev
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case duration
        case feeds
        case next
        case prev
    }

    public static func == (lhs: QueryFeedsResponse, rhs: QueryFeedsResponse) -> Bool {
        lhs.duration == rhs.duration &&
            lhs.feeds == rhs.feeds &&
            lhs.next == rhs.next &&
            lhs.prev == rhs.prev
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(duration)
        hasher.combine(feeds)
        hasher.combine(next)
        hasher.combine(prev)
    }
}
