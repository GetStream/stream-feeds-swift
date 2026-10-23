//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class CreateFeedsBatchRequest: Sendable, Encodable, JSONEncodable {
    /// List of feeds to create
    public let feeds: [FeedRequest]

    public init(feeds: [FeedRequest]) {
        self.feeds = feeds
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(feeds, forKey: .feeds)
    }
}

extension CreateFeedsBatchRequest: Hashable {
    public static func == (lhs: CreateFeedsBatchRequest, rhs: CreateFeedsBatchRequest) -> Bool {
        lhs.feeds == rhs.feeds
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(feeds)
    }
}
