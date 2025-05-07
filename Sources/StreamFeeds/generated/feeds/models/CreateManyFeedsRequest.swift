import Foundation
import StreamCore

public final class CreateManyFeedsRequest: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var feeds: [FeedPayload]

    public init(feeds: [FeedPayload]) {
        self.feeds = feeds
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case feeds
    }

    public static func == (lhs: CreateManyFeedsRequest, rhs: CreateManyFeedsRequest) -> Bool {
        lhs.feeds == rhs.feeds
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(feeds)
    }
}
