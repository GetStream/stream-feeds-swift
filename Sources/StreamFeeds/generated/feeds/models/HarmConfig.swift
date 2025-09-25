//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class HarmConfig: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var actionSequences: [ActionSequence]
    public var cooldownPeriod: Int
    public var harmTypes: [String]
    public var severity: Int
    public var threshold: Int

    public init(actionSequences: [ActionSequence], cooldownPeriod: Int, harmTypes: [String], severity: Int, threshold: Int) {
        self.actionSequences = actionSequences
        self.cooldownPeriod = cooldownPeriod
        self.harmTypes = harmTypes
        self.severity = severity
        self.threshold = threshold
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case actionSequences = "action_sequences"
        case cooldownPeriod = "cooldown_period"
        case harmTypes = "harm_types"
        case severity
        case threshold
    }

    public static func == (lhs: HarmConfig, rhs: HarmConfig) -> Bool {
        lhs.actionSequences == rhs.actionSequences &&
            lhs.cooldownPeriod == rhs.cooldownPeriod &&
            lhs.harmTypes == rhs.harmTypes &&
            lhs.severity == rhs.severity &&
            lhs.threshold == rhs.threshold
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(actionSequences)
        hasher.combine(cooldownPeriod)
        hasher.combine(harmTypes)
        hasher.combine(severity)
        hasher.combine(threshold)
    }
}
