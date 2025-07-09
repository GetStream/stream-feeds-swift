//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class AutomodSemanticFiltersRule: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public enum AutomodSemanticFiltersRuleAction: String, Sendable, Codable, CaseIterable {
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

    public var action: AutomodSemanticFiltersRuleAction
    public var name: String
    public var threshold: Float

    public init(action: AutomodSemanticFiltersRuleAction, name: String, threshold: Float) {
        self.action = action
        self.name = name
        self.threshold = threshold
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case action
        case name
        case threshold
    }

    public static func == (lhs: AutomodSemanticFiltersRule, rhs: AutomodSemanticFiltersRule) -> Bool {
        lhs.action == rhs.action &&
            lhs.name == rhs.name &&
            lhs.threshold == rhs.threshold
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(action)
        hasher.combine(name)
        hasher.combine(threshold)
    }
}
