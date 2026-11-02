//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// This event is sent when a moderation item is marked as reviewed
public final class ModerationMarkReviewedEvent: @unchecked Sendable, Event, Codable, JSONEncodable {
    public var createdAt: Date
    public var item: ReviewQueueItemResponse
    public var type: String = "moderation.mark_reviewed"

    public init(createdAt: Date, item: ReviewQueueItemResponse) {
        self.createdAt = createdAt
        self.item = item
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case createdAt = "created_at"
        case item
        case type
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
