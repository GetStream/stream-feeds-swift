//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Configuration for activity deletion action
public final class DeleteActivityRequestPayload: @unchecked Sendable, Codable, JSONEncodable {
    /// ID of the activity to delete (alternative to item_id)
    public var entityId: String?
    /// Type of the entity (required for delete_activity to distinguish v2 vs v3)
    public var entityType: String?
    /// Whether to permanently delete the activity
    public var hardDelete: Bool?
    /// Reason for deletion
    public var reason: String?

    public init(entityId: String? = nil, entityType: String? = nil, hardDelete: Bool? = nil, reason: String? = nil) {
        self.entityId = entityId
        self.entityType = entityType
        self.hardDelete = hardDelete
        self.reason = reason
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case entityId = "entity_id"
        case entityType = "entity_type"
        case hardDelete = "hard_delete"
        case reason
    }
}

extension DeleteActivityRequestPayload: Hashable {
    public static func == (lhs: DeleteActivityRequestPayload, rhs: DeleteActivityRequestPayload) -> Bool {
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
