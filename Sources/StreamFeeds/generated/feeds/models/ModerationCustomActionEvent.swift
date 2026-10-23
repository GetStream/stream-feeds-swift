//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// This event is sent when a custom moderation action is executed
public final class ModerationCustomActionEvent: Sendable, Event, Codable, JSONEncodable {
    /// The ID of the custom action that was executed
    public let actionId: String
    /// Additional options passed to the custom action
    public let actionOptions: [String: RawJSON]?
    public let createdAt: Date
    public let custom: [String: RawJSON]
    public let receivedAt: Date?
    public let reviewQueueItem: ReviewQueueItemResponse
    public let type: String

    public init(actionId: String, actionOptions: [String: RawJSON]? = nil, createdAt: Date, custom: [String: RawJSON], receivedAt: Date? = nil, reviewQueueItem: ReviewQueueItemResponse, type: String = "moderation.custom_action") {
        self.actionId = actionId
        self.actionOptions = actionOptions
        self.createdAt = createdAt
        self.custom = custom
        self.receivedAt = receivedAt
        self.reviewQueueItem = reviewQueueItem
        self.type = type
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.actionId = try container.decode(String.self, forKey: .actionId)
        self.actionOptions = try container.decodeIfPresent([String: RawJSON].self, forKey: .actionOptions)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.custom = try container.decode([String: RawJSON].self, forKey: .custom)
        self.receivedAt = try container.decodeIfPresent(Date.self, forKey: .receivedAt)
        self.reviewQueueItem = try container.decode(ReviewQueueItemResponse.self, forKey: .reviewQueueItem)
        self.type = try container.decode(String.self, forKey: .type)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(actionId, forKey: .actionId)
        try container.encodeIfPresent(actionOptions, forKey: .actionOptions)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(custom, forKey: .custom)
        try container.encodeIfPresent(receivedAt, forKey: .receivedAt)
        try container.encode(reviewQueueItem, forKey: .reviewQueueItem)
        try container.encode(type, forKey: .type)
    }
}

extension ModerationCustomActionEvent: Hashable {
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
