import Foundation
import StreamCore

public final class QueryFeedsResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var duration: String
    public var feeds: [FeedResponse]
    public var pager: PagerResponse

    public init(duration: String, feeds: [FeedResponse], pager: PagerResponse) {
        self.duration = duration
        self.feeds = feeds
        self.pager = pager
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case duration
        case feeds
        case pager
    }

    public static func == (lhs: QueryFeedsResponse, rhs: QueryFeedsResponse) -> Bool {
        lhs.duration == rhs.duration &&
            lhs.feeds == rhs.feeds &&
            lhs.pager == rhs.pager
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(duration)
        hasher.combine(feeds)
        hasher.combine(pager)
    }
}
