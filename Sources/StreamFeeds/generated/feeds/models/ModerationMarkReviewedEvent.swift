//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// This event is sent when a moderation item is marked as reviewed
public final class ModerationMarkReviewedEvent: Sendable, Event, Decodable {
    public let createdAt: Date
    public let item: ReviewQueueItemResponse
    public let type: String

    public init(createdAt: Date, item: ReviewQueueItemResponse, type: String = "moderation.mark_reviewed") {
        self.createdAt = createdAt
        self.item = item
        self.type = type
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.item = try container.decode(ReviewQueueItemResponse.self, forKey: .item)
        self.type = try container.decode(String.self, forKey: .type)
    }
}

extension ModerationMarkReviewedEvent: Hashable {
    public static func == (lhs: ModerationMarkReviewedEvent, rhs: ModerationMarkReviewedEvent) -> Bool {
        lhs.createdAt == rhs.createdAt &&
            lhs.item == rhs.item &&
            lhs.type == rhs.type
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(createdAt)
        hasher.combine(item)
        hasher.combine(type)
    }
}
