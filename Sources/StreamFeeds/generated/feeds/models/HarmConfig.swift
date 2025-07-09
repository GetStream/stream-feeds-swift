//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class HarmConfig: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var actionSequences: [ActionSequence]
    public var severity: Int

    public init(actionSequences: [ActionSequence], severity: Int) {
        self.actionSequences = actionSequences
        self.severity = severity
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case actionSequences = "action_sequences"
        case severity
    }

    public static func == (lhs: HarmConfig, rhs: HarmConfig) -> Bool {
        lhs.actionSequences == rhs.actionSequences &&
            lhs.severity == rhs.severity
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(actionSequences)
        hasher.combine(severity)
    }
}
