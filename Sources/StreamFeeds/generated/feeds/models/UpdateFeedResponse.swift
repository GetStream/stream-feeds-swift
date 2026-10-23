//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UpdateFeedResponse: Sendable, Decodable {
    public let duration: String
    public let feed: FeedResponse

    public init(duration: String, feed: FeedResponse) {
        self.duration = duration
        self.feed = feed
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.duration = try container.decode(String.self, forKey: .duration)
        self.feed = try container.decode(FeedResponse.self, forKey: .feed)
    }
}

extension UpdateFeedResponse: Hashable {
    public static func == (lhs: UpdateFeedResponse, rhs: UpdateFeedResponse) -> Bool {
        lhs.duration == rhs.duration &&
            lhs.feed == rhs.feed
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(duration)
        hasher.combine(feed)
    }
}
