//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class CreateFeedsBatchRequest: Sendable, Codable, JSONEncodable {
    /// If true, enriches the created feeds with own_* fields (own_follows, own_followings, own_capabilities, own_membership). Defaults to false for performance.
    public let enrichOwnFields: Bool?
    /// List of feeds to create
    public let feeds: [FeedRequest]

    public init(enrichOwnFields: Bool? = nil, feeds: [FeedRequest]) {
        self.enrichOwnFields = enrichOwnFields
        self.feeds = feeds
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.enrichOwnFields = try container.decodeIfPresent(Bool.self, forKey: .enrichOwnFields)
        self.feeds = try container.decode([FeedRequest].self, forKey: .feeds)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(enrichOwnFields, forKey: .enrichOwnFields)
        try container.encode(feeds, forKey: .feeds)
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
