//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class AutomodRule: @unchecked Sendable, Codable, JSONEncodable {
    /// What a moderation rule does when it matches.
    public var action: ModerationAction
    public var label: String
    public var threshold: Float

    public init(action: ModerationAction, label: String, threshold: Float) {
        self.action = action
        self.label = label
        self.threshold = threshold
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case action
        case label
        case threshold
    }
}

extension AutomodRule: Hashable {
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
