//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UpdateFeedResponse: Sendable, Decodable {
    public let feed: FeedResponse

    public init(feed: FeedResponse) {
        self.feed = feed
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.feed = try container.decode(FeedResponse.self, forKey: .feed)
    }
}

extension UpdateFeedResponse: Hashable {
    public static func == (lhs: UpdateFeedResponse, rhs: UpdateFeedResponse) -> Bool {
        lhs.feed == rhs.feed
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(feed)
    }
}
