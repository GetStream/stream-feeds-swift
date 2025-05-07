import Foundation
import StreamCore

public final class UpdateBookmarkRequest: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var custom: [String: RawJSON]?
    public var feedId: String
    public var feedType: String

    public init(custom: [String: RawJSON]? = nil, feedId: String, feedType: String) {
        self.custom = custom
        self.feedId = feedId
        self.feedType = feedType
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case custom
        case feedId = "feed_id"
        case feedType = "feed_type"
    }

    public static func == (lhs: UpdateBookmarkRequest, rhs: UpdateBookmarkRequest) -> Bool {
        lhs.custom == rhs.custom &&
            lhs.feedId == rhs.feedId &&
            lhs.feedType == rhs.feedType
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(custom)
        hasher.combine(feedId)
        hasher.combine(feedType)
    }
}
