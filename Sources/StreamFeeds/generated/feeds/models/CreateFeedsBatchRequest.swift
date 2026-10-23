//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class CreateFeedsBatchRequest: @unchecked Sendable, Codable, JSONEncodable {
    /// List of feeds to create
    public var feeds: [FeedRequest]

    public init(feeds: [FeedRequest]) {
        self.feeds = feeds
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case feeds
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
