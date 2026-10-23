//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class BlockListRuleAction: RawRepresentable, Codable, Hashable, Sendable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public static let bounce = BlockListRuleAction(rawValue: "bounce")
    public static let bounceFlag = BlockListRuleAction(rawValue: "bounce_flag")
    public static let bounceRemove = BlockListRuleAction(rawValue: "bounce_remove")
    public static let flag = BlockListRuleAction(rawValue: "flag")
    public static let mask = BlockListRuleAction(rawValue: "mask")
    public static let maskFlag = BlockListRuleAction(rawValue: "mask_flag")
    public static let remove = BlockListRuleAction(rawValue: "remove")
    public static let shadow = BlockListRuleAction(rawValue: "shadow")
}

public final class BlockListRule: Sendable, Codable, JSONEncodable {
    public let action: BlockListRuleAction
    public let name: String
    public let team: String

    public init(action: BlockListRuleAction, name: String, team: String) {
        self.action = action
        self.name = name
        self.team = team
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.action = try container.decode(BlockListRuleAction.self, forKey: .action)
        self.name = try container.decode(String.self, forKey: .name)
        self.team = try container.decode(String.self, forKey: .team)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(action, forKey: .action)
        try container.encode(name, forKey: .name)
        try container.encode(team, forKey: .team)
    }
}

extension BlockListRule: Hashable {
    public static func == (lhs: BlockListRule, rhs: BlockListRule) -> Bool {
        lhs.action == rhs.action &&
            lhs.name == rhs.name &&
            lhs.team == rhs.team
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(action)
        hasher.combine(name)
        hasher.combine(team)
    }
}
