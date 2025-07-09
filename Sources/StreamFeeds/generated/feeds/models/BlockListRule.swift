//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class BlockListRule: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public enum BlockListRuleAction: String, Sendable, Codable, CaseIterable {
        case bounce
        case bounceFlag = "bounce_flag"
        case bounceRemove = "bounce_remove"
        case flag
        case maskFlag = "mask_flag"
        case remove
        case shadow
        case unknown = "_unknown"

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let decodedValue = try? container.decode(String.self),
               let value = Self(rawValue: decodedValue) {
                self = value
            } else {
                self = .unknown
            }
        }
    }

    public var action: BlockListRuleAction
    public var name: String
    public var team: String

    public init(action: BlockListRuleAction, name: String, team: String) {
        self.action = action
        self.name = name
        self.team = team
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case action
        case name
        case team
    }

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
