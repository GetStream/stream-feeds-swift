//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class ModerationCustomActionEvent: @unchecked Sendable,  Event, Codable, JSONEncodable, Hashable {
    public var actionId: String
    public var actionOptions: [String: RawJSON]?
    public var createdAt: Date
    public var custom: [String: RawJSON]
    public var receivedAt: Date?
    public var reviewQueueItem: ReviewQueueItemResponse
    public var type: String = "moderation.custom_action"

    public init(actionId: String, actionOptions: [String: RawJSON]? = nil, createdAt: Date, custom: [String: RawJSON], receivedAt: Date? = nil, reviewQueueItem: ReviewQueueItemResponse) {
        self.actionId = actionId
        self.actionOptions = actionOptions
        self.createdAt = createdAt
        self.custom = custom
        self.receivedAt = receivedAt
        self.reviewQueueItem = reviewQueueItem
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case actionId = "action_id"
        case actionOptions = "action_options"
        case createdAt = "created_at"
        case custom
        case receivedAt = "received_at"
        case reviewQueueItem = "review_queue_item"
        case type
    }

    public static func == (lhs: ModerationCustomActionEvent, rhs: ModerationCustomActionEvent) -> Bool {
        lhs.actionId == rhs.actionId &&
        lhs.actionOptions == rhs.actionOptions &&
        lhs.createdAt == rhs.createdAt &&
        lhs.custom == rhs.custom &&
        lhs.receivedAt == rhs.receivedAt &&
        lhs.reviewQueueItem == rhs.reviewQueueItem &&
        lhs.type == rhs.type
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(actionId)
        hasher.combine(actionOptions)
        hasher.combine(createdAt)
        hasher.combine(custom)
        hasher.combine(receivedAt)
        hasher.combine(reviewQueueItem)
        hasher.combine(type)
    }
}
