//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// This event is sent when content is flagged for moderation
public final class ModerationFlaggedEvent: Sendable, Event, Codable, JSONEncodable {
    /// The type of content that was flagged
    public let contentType: String
    public let createdAt: Date
    public let custom: [String: RawJSON]
    /// The ID of the flagged content
    public let objectId: String
    public let receivedAt: Date?
    public let type: String

    public init(contentType: String, createdAt: Date, custom: [String: RawJSON], objectId: String, receivedAt: Date? = nil, type: String = "moderation.flagged") {
        self.contentType = contentType
        self.createdAt = createdAt
        self.custom = custom
        self.objectId = objectId
        self.receivedAt = receivedAt
        self.type = type
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.contentType = try container.decode(String.self, forKey: .contentType)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.custom = try container.decode([String: RawJSON].self, forKey: .custom)
        self.objectId = try container.decode(String.self, forKey: .objectId)
        self.receivedAt = try container.decodeIfPresent(Date.self, forKey: .receivedAt)
        self.type = try container.decode(String.self, forKey: .type)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(contentType, forKey: .contentType)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(custom, forKey: .custom)
        try container.encode(objectId, forKey: .objectId)
        try container.encodeIfPresent(receivedAt, forKey: .receivedAt)
        try container.encode(type, forKey: .type)
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
