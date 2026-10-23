//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Configuration for reaction deletion action
public final class DeleteReactionRequestPayload: Sendable, Codable, JSONEncodable {
    /// ID of the reaction to delete (alternative to item_id)
    public let entityId: String?
    /// Type of the entity
    public let entityType: String?
    /// Whether to permanently delete the reaction
    public let hardDelete: Bool?
    /// Reason for deletion
    public let reason: String?

    public init(entityId: String? = nil, entityType: String? = nil, hardDelete: Bool? = nil, reason: String? = nil) {
        self.entityId = entityId
        self.entityType = entityType
        self.hardDelete = hardDelete
        self.reason = reason
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.entityId = try container.decodeIfPresent(String.self, forKey: .entityId)
        self.entityType = try container.decodeIfPresent(String.self, forKey: .entityType)
        self.hardDelete = try container.decodeIfPresent(Bool.self, forKey: .hardDelete)
        self.reason = try container.decodeIfPresent(String.self, forKey: .reason)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(entityId, forKey: .entityId)
        try container.encodeIfPresent(entityType, forKey: .entityType)
        try container.encodeIfPresent(hardDelete, forKey: .hardDelete)
        try container.encodeIfPresent(reason, forKey: .reason)
    }
}

extension DeleteReactionRequestPayload: Hashable {
    public static func == (lhs: DeleteReactionRequestPayload, rhs: DeleteReactionRequestPayload) -> Bool {
        lhs.entityId == rhs.entityId &&
            lhs.entityType == rhs.entityType &&
            lhs.hardDelete == rhs.hardDelete &&
            lhs.reason == rhs.reason
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(entityId)
        hasher.combine(entityType)
        hasher.combine(hardDelete)
        hasher.combine(reason)
    }
}
