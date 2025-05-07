import Foundation
import StreamCore

public final class CreateManyFeedsResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var duration: String
    public var feeds: [Feed]

    public init(duration: String, feeds: [Feed]) {
        self.duration = duration
        self.feeds = feeds
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case duration
        case feeds
    }

    public static func == (lhs: CreateManyFeedsResponse, rhs: CreateManyFeedsResponse) -> Bool {
        lhs.duration == rhs.duration &&
            lhs.feeds == rhs.feeds
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(duration)
        hasher.combine(feeds)
    }
}
