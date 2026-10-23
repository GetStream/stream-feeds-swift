//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Configuration for a moderation action
public final class ModerationActionConfigResponse: @unchecked Sendable, Codable, JSONEncodable {
    /// The action to take
    public var action: String
    /// Custom data for the action
    public var custom: [String: RawJSON]?
    /// Description of what this action does
    public var description: String
    /// Type of entity this action applies to
    public var entityType: String
    /// Icon for the dashboard
    public var icon: String
    /// Display order (lower numbers shown first)
    public var order: Int

    public init(action: String, custom: [String: RawJSON]? = nil, description: String, entityType: String, icon: String, order: Int) {
        self.action = action
        self.custom = custom
        self.description = description
        self.entityType = entityType
        self.icon = icon
        self.order = order
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case action
        case custom
        case description
        case entityType = "entity_type"
        case icon
        case order
    }
}

extension ModerationActionConfigResponse: Hashable {
    public static func == (lhs: ModerationActionConfigResponse, rhs: ModerationActionConfigResponse) -> Bool {
        lhs.action == rhs.action &&
            lhs.custom == rhs.custom &&
            lhs.description == rhs.description &&
            lhs.entityType == rhs.entityType &&
            lhs.icon == rhs.icon &&
            lhs.order == rhs.order
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(action)
        hasher.combine(custom)
        hasher.combine(description)
        hasher.combine(entityType)
        hasher.combine(icon)
        hasher.combine(order)
    }
}
