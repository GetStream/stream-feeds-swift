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
    public let subclassifications: [String: RawJSON]?

    public init(action: ModerationAction, label: String, minConfidence: Double, subclassifications: [String: RawJSON]? = nil) {
        self.action = action
        self.label = label
        self.minConfidence = minConfidence
        self.subclassifications = subclassifications
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.action = try container.decode(ModerationAction.self, forKey: .action)
        self.label = try container.decode(String.self, forKey: .label)
        self.minConfidence = try container.decode(Double.self, forKey: .minConfidence)
        self.subclassifications = try container.decodeIfPresent([String: RawJSON].self, forKey: .subclassifications)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(action, forKey: .action)
        try container.encode(label, forKey: .label)
        try container.encode(minConfidence, forKey: .minConfidence)
        try container.encodeIfPresent(subclassifications, forKey: .subclassifications)
    }
}

extension AWSRekognitionRule: Hashable {
    public static func == (lhs: AWSRekognitionRule, rhs: AWSRekognitionRule) -> Bool {
        lhs.action == rhs.action &&
            lhs.label == rhs.label &&
            lhs.minConfidence == rhs.minConfidence &&
            lhs.subclassifications == rhs.subclassifications
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(action)
        hasher.combine(label)
        hasher.combine(minConfidence)
        hasher.combine(subclassifications)
    }
}
