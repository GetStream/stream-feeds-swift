//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class QueryReviewQueueResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var actionConfig: [String: [ModerationActionConfig]]
    public var duration: String
    public var items: [ReviewQueueItemResponse]
    public var next: String?
    public var prev: String?
    public var stats: [String: RawJSON]

    public init(actionConfig: [String: [ModerationActionConfig]], duration: String, items: [ReviewQueueItemResponse], next: String? = nil, prev: String? = nil, stats: [String: RawJSON]) {
        self.actionConfig = actionConfig
        self.duration = duration
        self.items = items
        self.next = next
        self.prev = prev
        self.stats = stats
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case actionConfig = "action_config"
        case duration
        case items
        case next
        case prev
        case stats
    }

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
