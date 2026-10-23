//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// This event is sent when content is flagged for moderation
public final class ModerationFlaggedEvent: @unchecked Sendable, Event, Codable, JSONEncodable {
    public var createdAt: Date
    /// The ID of the flagged content
    public var objectId: String
    public var type: String = "moderation.flagged"

    public init(createdAt: Date, objectId: String) {
        self.createdAt = createdAt
        self.objectId = objectId
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case createdAt = "created_at"
        case objectId = "object_id"
        case type
    }
}

extension ModerationFlaggedEvent: Hashable {
    public static func == (lhs: ModerationFlaggedEvent, rhs: ModerationFlaggedEvent) -> Bool {
        lhs.createdAt == rhs.createdAt &&
            lhs.objectId == rhs.objectId &&
            lhs.type == rhs.type
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(createdAt)
        hasher.combine(objectId)
        hasher.combine(type)
    }
}
