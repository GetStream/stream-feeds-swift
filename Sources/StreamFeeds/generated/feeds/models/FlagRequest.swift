//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class FlagRequest: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var custom: [String: RawJSON]?
    public var entityCreatorId: String?
    public var entityId: String
    public var entityType: String
    public var moderationPayload: ModerationPayload?
    public var reason: String?

    public init(custom: [String: RawJSON]? = nil, entityCreatorId: String? = nil, entityId: String, entityType: String, moderationPayload: ModerationPayload? = nil, reason: String? = nil) {
        self.custom = custom
        self.entityCreatorId = entityCreatorId
        self.entityId = entityId
        self.entityType = entityType
        self.moderationPayload = moderationPayload
        self.reason = reason
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case custom
        case entityCreatorId = "entity_creator_id"
        case entityId = "entity_id"
        case entityType = "entity_type"
        case moderationPayload = "moderation_payload"
        case reason
    }

    public static func == (lhs: FlagRequest, rhs: FlagRequest) -> Bool {
        lhs.custom == rhs.custom &&
            lhs.entityCreatorId == rhs.entityCreatorId &&
            lhs.entityId == rhs.entityId &&
            lhs.entityType == rhs.entityType &&
            lhs.moderationPayload == rhs.moderationPayload &&
            lhs.reason == rhs.reason
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(custom)
        hasher.combine(entityCreatorId)
        hasher.combine(entityId)
        hasher.combine(entityType)
        hasher.combine(moderationPayload)
        hasher.combine(reason)
    }
}
