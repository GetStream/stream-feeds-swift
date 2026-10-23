//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// This event is sent when content is flagged for moderation
public final class ModerationFlaggedEvent: @unchecked Sendable, Event, Codable, JSONEncodable {
    /// The type of content that was flagged
    public var contentType: String
    public var createdAt: Date
    public var custom: [String: RawJSON]
    /// The ID of the flagged content
    public var objectId: String
    public var receivedAt: Date?
    public var type: String = "moderation.flagged"

    public init(
        contentType: String,
        createdAt: Date,
        custom: [String: RawJSON],
        objectId: String,
        receivedAt: Date? = nil
    ) {
        self.contentType = contentType
        self.createdAt = createdAt
        self.custom = custom
        self.objectId = objectId
        self.receivedAt = receivedAt
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case contentType = "content_type"
        case createdAt = "created_at"
        case custom
        case objectId = "object_id"
        case receivedAt = "received_at"
        case type
    }
}

extension ModerationFlaggedEvent: Hashable {
    public static func == (lhs: ModerationFlaggedEvent, rhs: ModerationFlaggedEvent) -> Bool {
        lhs.contentType == rhs.contentType &&
            lhs.createdAt == rhs.createdAt &&
            lhs.custom == rhs.custom &&
            lhs.objectId == rhs.objectId &&
            lhs.receivedAt == rhs.receivedAt &&
            lhs.type == rhs.type
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(contentType)
        hasher.combine(createdAt)
        hasher.combine(custom)
        hasher.combine(objectId)
        hasher.combine(receivedAt)
        hasher.combine(type)
    }
}
