//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class AutomodSemanticFiltersRule: @unchecked Sendable, Codable, JSONEncodable {
    /// What a moderation rule does when it matches.
    public var action: ModerationAction
    public var name: String
    public var threshold: Float

    public init(action: ModerationAction, name: String, threshold: Float) {
        self.action = action
        self.name = name
        self.threshold = threshold
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case action
        case name
        case threshold
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
