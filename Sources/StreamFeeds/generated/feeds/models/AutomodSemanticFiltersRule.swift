//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class AutomodSemanticFiltersRule: Sendable, Codable, JSONEncodable {
    /// What a moderation rule does when it matches.
    public let action: ModerationAction
    public let name: String
    public let threshold: Double

    public init(action: ModerationAction, name: String, threshold: Double) {
        self.action = action
        self.name = name
        self.threshold = threshold
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.action = try container.decode(ModerationAction.self, forKey: .action)
        self.name = try container.decode(String.self, forKey: .name)
        self.threshold = try container.decode(Double.self, forKey: .threshold)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(action, forKey: .action)
        try container.encode(name, forKey: .name)
        try container.encode(threshold, forKey: .threshold)
    }
}

extension AutomodSemanticFiltersRule: Hashable {
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
