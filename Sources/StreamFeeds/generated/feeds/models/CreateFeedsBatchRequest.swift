//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class CreateFeedsBatchRequest: @unchecked Sendable, Codable, JSONEncodable {
    /// If true, enriches the created feeds with own_* fields (own_follows, own_followings, own_capabilities, own_membership). Defaults to false for performance.
    public var enrichOwnFields: Bool?
    /// List of feeds to create
    public var feeds: [FeedRequest]

    public init(enrichOwnFields: Bool? = nil, feeds: [FeedRequest]) {
        self.enrichOwnFields = enrichOwnFields
        self.feeds = feeds
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case enrichOwnFields = "enrich_own_fields"
        case feeds
    }
}

extension CreateFeedsBatchRequest: Hashable {
    public static func == (lhs: CreateFeedsBatchRequest, rhs: CreateFeedsBatchRequest) -> Bool {
        lhs.enrichOwnFields == rhs.enrichOwnFields &&
            lhs.feeds == rhs.feeds
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(enrichOwnFields)
        hasher.combine(feeds)
    }
}
