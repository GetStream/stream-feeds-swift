//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class QueryReviewQueueResponse: Sendable, Codable, JSONEncodable {
    /// Configuration for moderation actions
    public let actionConfig: [String: [ModerationActionConfigResponse]]
    public let defaultActionConfig: [String: [ModerationActionConfigResponse]]?
    public let duration: String
    public let filterConfig: FilterConfigResponse?
    /// List of review queue items
    public let items: [ReviewQueueItemResponse]
    public let next: String?
    public let prev: String?
    /// Statistics about the review queue
    public let stats: [String: RawJSON]

    public init(actionConfig: [String: [ModerationActionConfigResponse]], defaultActionConfig: [String: [ModerationActionConfigResponse]]? = nil, duration: String, filterConfig: FilterConfigResponse? = nil, items: [ReviewQueueItemResponse], next: String? = nil, prev: String? = nil, stats: [String: RawJSON]) {
        self.actionConfig = actionConfig
        self.defaultActionConfig = defaultActionConfig
        self.duration = duration
        self.filterConfig = filterConfig
        self.items = items
        self.next = next
        self.prev = prev
        self.stats = stats
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.actionConfig = try container.decode([String: [ModerationActionConfigResponse]].self, forKey: .actionConfig)
        self.defaultActionConfig = try container.decodeIfPresent([String: [ModerationActionConfigResponse]].self, forKey: .defaultActionConfig)
        self.duration = try container.decode(String.self, forKey: .duration)
        self.filterConfig = try container.decodeIfPresent(FilterConfigResponse.self, forKey: .filterConfig)
        self.items = try container.decode([ReviewQueueItemResponse].self, forKey: .items)
        self.next = try container.decodeIfPresent(String.self, forKey: .next)
        self.prev = try container.decodeIfPresent(String.self, forKey: .prev)
        self.stats = try container.decode([String: RawJSON].self, forKey: .stats)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(actionConfig, forKey: .actionConfig)
        try container.encodeIfPresent(defaultActionConfig, forKey: .defaultActionConfig)
        try container.encode(duration, forKey: .duration)
        try container.encodeIfPresent(filterConfig, forKey: .filterConfig)
        try container.encode(items, forKey: .items)
        try container.encodeIfPresent(next, forKey: .next)
        try container.encodeIfPresent(prev, forKey: .prev)
        try container.encode(stats, forKey: .stats)
    }
}

extension QueryReviewQueueResponse: Hashable {
    public static func == (lhs: QueryReviewQueueResponse, rhs: QueryReviewQueueResponse) -> Bool {
        lhs.actionConfig == rhs.actionConfig &&
            lhs.defaultActionConfig == rhs.defaultActionConfig &&
            lhs.duration == rhs.duration &&
            lhs.filterConfig == rhs.filterConfig &&
            lhs.items == rhs.items &&
            lhs.next == rhs.next &&
            lhs.prev == rhs.prev &&
            lhs.stats == rhs.stats
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(actionConfig)
        hasher.combine(defaultActionConfig)
        hasher.combine(duration)
        hasher.combine(filterConfig)
        hasher.combine(items)
        hasher.combine(next)
        hasher.combine(prev)
        hasher.combine(stats)
    }
}
