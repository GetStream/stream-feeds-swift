//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UpdateFeedResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var duration: String
    public var feed: FeedResponse

    public init(duration: String, feed: FeedResponse) {
        self.duration = duration
        self.feed = feed
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case duration
        case feed
    }

    public static func == (lhs: UpdateFeedResponse, rhs: UpdateFeedResponse) -> Bool {
        lhs.duration == rhs.duration &&
            lhs.feed == rhs.feed
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(duration)
        hasher.combine(feed)
    }
}
