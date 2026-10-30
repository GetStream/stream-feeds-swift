//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class QueryReviewQueueResponse: Sendable, Decodable {
    /// Configuration for moderation actions
    public let actionConfig: [String: [ModerationActionConfigResponse]]
    public let duration: String
    /// List of review queue items
    public let items: [ReviewQueueItemResponse]
    public let next: String?
    public let prev: String?
    /// Statistics about the review queue
    public let stats: [String: RawJSON]

    public init(actionConfig: [String: [ModerationActionConfigResponse]], duration: String, items: [ReviewQueueItemResponse], next: String? = nil, prev: String? = nil, stats: [String: RawJSON]) {
        self.actionConfig = actionConfig
        self.duration = duration
        self.items = items
        self.next = next
        self.prev = prev
        self.stats = stats
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.actionConfig = try container.decode([String: [ModerationActionConfigResponse]].self, forKey: .actionConfig)
        self.duration = try container.decode(String.self, forKey: .duration)
        self.items = try container.decode([ReviewQueueItemResponse].self, forKey: .items)
        self.next = try container.decodeIfPresent(String.self, forKey: .next)
        self.prev = try container.decodeIfPresent(String.self, forKey: .prev)
        self.stats = try container.decode([String: RawJSON].self, forKey: .stats)
    }
}

extension QueryReviewQueueResponse: Hashable {
    public static func == (lhs: QueryReviewQueueResponse, rhs: QueryReviewQueueResponse) -> Bool {
        lhs.actionConfig == rhs.actionConfig &&
            lhs.duration == rhs.duration &&
            lhs.items == rhs.items &&
            lhs.next == rhs.next &&
            lhs.prev == rhs.prev &&
            lhs.stats == rhs.stats
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(actionConfig)
        hasher.combine(duration)
        hasher.combine(items)
        hasher.combine(next)
        hasher.combine(prev)
        hasher.combine(stats)
    }
}
