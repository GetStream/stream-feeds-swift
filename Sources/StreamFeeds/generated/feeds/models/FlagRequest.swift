//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class FlagRequest: Sendable, Encodable, JSONEncodable {
    /// Additional metadata about the flag
    public let custom: [String: RawJSON]?
    /// Unique identifier of the entity being flagged
    public let entityId: String
    /// Type of entity being flagged (e.g., message, user)
    public let entityType: String
    public let moderationPayload: ModerationPayload?
    /// Optional explanation for why the content is being flagged
    public let reason: String?

    public init(custom: [String: RawJSON]? = nil, entityId: String, entityType: String, moderationPayload: ModerationPayload? = nil, reason: String? = nil) {
        self.custom = custom
        self.entityId = entityId
        self.entityType = entityType
        self.moderationPayload = moderationPayload
        self.reason = reason
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(custom, forKey: .custom)
        try container.encode(entityId, forKey: .entityId)
        try container.encode(entityType, forKey: .entityType)
        try container.encodeIfPresent(moderationPayload, forKey: .moderationPayload)
        try container.encodeIfPresent(reason, forKey: .reason)
    }
}

extension FlagRequest: Hashable {
    public static func == (lhs: FlagRequest, rhs: FlagRequest) -> Bool {
        lhs.custom == rhs.custom &&
            lhs.entityId == rhs.entityId &&
            lhs.entityType == rhs.entityType &&
            lhs.moderationPayload == rhs.moderationPayload &&
            lhs.reason == rhs.reason
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(custom)
        hasher.combine(entityId)
        hasher.combine(entityType)
        hasher.combine(moderationPayload)
        hasher.combine(reason)
    }
}
