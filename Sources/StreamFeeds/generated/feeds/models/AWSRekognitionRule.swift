//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class AWSRekognitionRuleAction: RawRepresentable, Codable, Hashable, Sendable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public static let bounce = AWSRekognitionRuleAction(rawValue: "bounce")
    public static let bounceFlag = AWSRekognitionRuleAction(rawValue: "bounce_flag")
    public static let bounceRemove = AWSRekognitionRuleAction(rawValue: "bounce_remove")
    public static let flag = AWSRekognitionRuleAction(rawValue: "flag")
    public static let remove = AWSRekognitionRuleAction(rawValue: "remove")
    public static let shadow = AWSRekognitionRuleAction(rawValue: "shadow")
}

public final class AWSRekognitionRule: Sendable, Codable, JSONEncodable {
    public let action: AWSRekognitionRuleAction
    public let label: String
    public let minConfidence: Double

    public init(action: AWSRekognitionRuleAction, label: String, minConfidence: Double) {
        self.action = action
        self.label = label
        self.minConfidence = minConfidence
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.action = try container.decode(AWSRekognitionRuleAction.self, forKey: .action)
        self.label = try container.decode(String.self, forKey: .label)
        self.minConfidence = try container.decode(Double.self, forKey: .minConfidence)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(action, forKey: .action)
        try container.encode(label, forKey: .label)
        try container.encode(minConfidence, forKey: .minConfidence)
    }
}

extension AWSRekognitionRule: Hashable {
    public static func == (lhs: AWSRekognitionRule, rhs: AWSRekognitionRule) -> Bool {
        lhs.action == rhs.action &&
            lhs.label == rhs.label &&
            lhs.minConfidence == rhs.minConfidence
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(action)
        hasher.combine(label)
        hasher.combine(minConfidence)
    }
}
