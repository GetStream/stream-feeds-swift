import Foundation
import StreamCore

public final class ModerationActionConfig: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var action: String
    public var custom: [String: RawJSON]
    public var description: String
    public var entityType: String
    public var icon: String
    public var order: Int

    public init(action: String, custom: [String: RawJSON], description: String, entityType: String, icon: String, order: Int) {
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

    public static func == (lhs: ModerationActionConfig, rhs: ModerationActionConfig) -> Bool {
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
