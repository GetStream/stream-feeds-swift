//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// This event is sent when a moderation item is marked as reviewed
public final class ModerationMarkReviewedEvent: Sendable, Event, Codable, JSONEncodable {
    public let createdAt: Date
    public let custom: [String: RawJSON]
    public let item: ReviewQueueItemResponse
    public let receivedAt: Date?
    public let type: String

    public init(createdAt: Date, custom: [String: RawJSON], item: ReviewQueueItemResponse, receivedAt: Date? = nil, type: String = "moderation.mark_reviewed") {
        self.createdAt = createdAt
        self.custom = custom
        self.item = item
        self.receivedAt = receivedAt
        self.type = type
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.custom = try container.decode([String: RawJSON].self, forKey: .custom)
        self.item = try container.decode(ReviewQueueItemResponse.self, forKey: .item)
        self.receivedAt = try container.decodeIfPresent(Date.self, forKey: .receivedAt)
        self.type = try container.decode(String.self, forKey: .type)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(custom, forKey: .custom)
        try container.encode(item, forKey: .item)
        try container.encodeIfPresent(receivedAt, forKey: .receivedAt)
        try container.encode(type, forKey: .type)
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
