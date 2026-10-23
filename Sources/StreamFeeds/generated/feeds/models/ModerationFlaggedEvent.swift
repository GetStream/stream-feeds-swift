//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// This event is sent when content is flagged for moderation
public final class ModerationFlaggedEvent: Sendable, Event, Decodable {
    public let createdAt: Date
    /// The ID of the flagged content
    public let objectId: String
    public let type: String

    public init(createdAt: Date, objectId: String, type: String = "moderation.flagged") {
        self.createdAt = createdAt
        self.objectId = objectId
        self.type = type
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.objectId = try container.decode(String.self, forKey: .objectId)
        self.type = try container.decode(String.self, forKey: .type)
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
