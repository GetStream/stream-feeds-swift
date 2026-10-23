//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class CreateFeedsBatchResponse: Sendable, Codable, JSONEncodable {
    public let duration: String
    /// List of created feeds
    public let feeds: [FeedResponse]

    public init(duration: String, feeds: [FeedResponse]) {
        self.duration = duration
        self.feeds = feeds
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.duration = try container.decode(String.self, forKey: .duration)
        self.feeds = try container.decode([FeedResponse].self, forKey: .feeds)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(duration, forKey: .duration)
        try container.encode(feeds, forKey: .feeds)
    }
}

extension CreateFeedsBatchResponse: Hashable {
    public static func == (lhs: CreateFeedsBatchResponse, rhs: CreateFeedsBatchResponse) -> Bool {
        lhs.duration == rhs.duration &&
            lhs.feeds == rhs.feeds
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(duration)
        hasher.combine(feeds)
    }
}
