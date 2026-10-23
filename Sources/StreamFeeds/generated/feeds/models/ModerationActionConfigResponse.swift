//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Configuration for a moderation action
public final class ModerationActionConfigResponse: Sendable, Codable, JSONEncodable {
    /// The action to take
    public let action: String
    /// Custom data for the action
    public let custom: [String: RawJSON]?
    /// Description of what this action does
    public let description: String
    /// Type of entity this action applies to
    public let entityType: String
    /// Icon for the dashboard
    public let icon: String
    /// Display order (lower numbers shown first)
    public let order: Int

    public init(action: String, custom: [String: RawJSON]? = nil, description: String, entityType: String, icon: String, order: Int) {
        self.action = action
        self.custom = custom
        self.description = description
        self.entityType = entityType
        self.icon = icon
        self.order = order
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.action = try container.decode(String.self, forKey: .action)
        self.custom = try container.decodeIfPresent([String: RawJSON].self, forKey: .custom)
        self.description = try container.decode(String.self, forKey: .description)
        self.entityType = try container.decode(String.self, forKey: .entityType)
        self.icon = try container.decode(String.self, forKey: .icon)
        self.order = try container.decode(Int.self, forKey: .order)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(action, forKey: .action)
        try container.encodeIfPresent(custom, forKey: .custom)
        try container.encode(description, forKey: .description)
        try container.encode(entityType, forKey: .entityType)
        try container.encode(icon, forKey: .icon)
        try container.encode(order, forKey: .order)
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
