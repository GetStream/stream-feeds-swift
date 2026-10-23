//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class FlagRequest: @unchecked Sendable, Codable, JSONEncodable {
    /// Additional metadata about the flag
    public var custom: [String: RawJSON]?
    /// Unique identifier of the entity being flagged
    public var entityId: String
    /// Type of entity being flagged (e.g., message, user)
    public var entityType: String
    public var moderationPayload: ModerationPayload?
    /// Optional explanation for why the content is being flagged
    public var reason: String?

    public init(
        custom: [String: RawJSON]? = nil,
        entityId: String,
        entityType: String,
        moderationPayload: ModerationPayload? = nil,
        reason: String? = nil
    ) {
        self.custom = custom
        self.entityId = entityId
        self.entityType = entityType
        self.moderationPayload = moderationPayload
        self.reason = reason
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case custom
        case entityId = "entity_id"
        case entityType = "entity_type"
        case moderationPayload = "moderation_payload"
        case reason
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
