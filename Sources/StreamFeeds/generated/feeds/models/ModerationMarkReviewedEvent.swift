import Foundation
//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import StreamCore

public final class ModerationMarkReviewedEvent: @unchecked Sendable, Event, Codable, JSONEncodable, Hashable {
    public var createdAt: Date
    public var item: ReviewQueueItem?
    public var type: String = "moderation.mark_reviewed"
    public var user: User?

    public init(createdAt: Date, item: ReviewQueueItem? = nil, user: User? = nil) {
        self.createdAt = createdAt
        self.item = item
        self.user = user
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case createdAt = "created_at"
        case item
        case type
        case user
    }

    public static func == (lhs: ModerationMarkReviewedEvent, rhs: ModerationMarkReviewedEvent) -> Bool {
        lhs.createdAt == rhs.createdAt &&
            lhs.item == rhs.item &&
            lhs.type == rhs.type &&
            lhs.user == rhs.user
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(createdAt)
        hasher.combine(item)
        hasher.combine(type)
        hasher.combine(user)
    }
}
