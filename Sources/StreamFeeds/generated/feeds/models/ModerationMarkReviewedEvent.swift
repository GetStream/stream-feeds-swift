//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// This event is sent when a moderation item is marked as reviewed
public final class ModerationMarkReviewedEvent: @unchecked Sendable, Event, Codable, JSONEncodable {
    public var createdAt: Date
    public var custom: [String: RawJSON]
    public var item: ReviewQueueItemResponse
    public var receivedAt: Date?
    public var type: String = "moderation.mark_reviewed"

    public init(
        createdAt: Date,
        custom: [String: RawJSON],
        item: ReviewQueueItemResponse,
        receivedAt: Date? = nil
    ) {
        self.createdAt = createdAt
        self.custom = custom
        self.item = item
        self.receivedAt = receivedAt
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case createdAt = "created_at"
        case custom
        case item
        case receivedAt = "received_at"
        case type
    }
}

extension ModerationMarkReviewedEvent: Hashable {
    public static func == (lhs: ModerationMarkReviewedEvent, rhs: ModerationMarkReviewedEvent) -> Bool {
        lhs.createdAt == rhs.createdAt &&
            lhs.custom == rhs.custom &&
            lhs.item == rhs.item &&
            lhs.receivedAt == rhs.receivedAt &&
            lhs.type == rhs.type
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(createdAt)
        hasher.combine(custom)
        hasher.combine(item)
        hasher.combine(receivedAt)
        hasher.combine(type)
    }
}
