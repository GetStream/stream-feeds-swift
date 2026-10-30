//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class AWSRekognitionRule: Sendable, Codable, JSONEncodable {
    /// What a moderation rule does when it matches.
    public let action: ModerationAction
    public let label: String
    public let minConfidence: Double

    public init(action: ModerationAction, label: String, minConfidence: Double) {
        self.action = action
        self.label = label
        self.minConfidence = minConfidence
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.action = try container.decode(ModerationAction.self, forKey: .action)
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
