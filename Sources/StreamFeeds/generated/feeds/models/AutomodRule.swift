//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class AutomodRule: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public enum AutomodRuleAction: String, Sendable, Codable, CaseIterable {
        case bounce
        case bounceFlag = "bounce_flag"
        case bounceRemove = "bounce_remove"
        case flag
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

    public var action: AutomodRuleAction
    public var label: String
    public var threshold: Float

    public init(action: AutomodRuleAction, label: String, threshold: Float) {
        self.action = action
        self.label = label
        self.threshold = threshold
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case action
        case label
        case threshold
    }

    public static func == (lhs: AutomodRule, rhs: AutomodRule) -> Bool {
        lhs.action == rhs.action &&
            lhs.label == rhs.label &&
            lhs.threshold == rhs.threshold
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(action)
        hasher.combine(label)
        hasher.combine(threshold)
    }
}
