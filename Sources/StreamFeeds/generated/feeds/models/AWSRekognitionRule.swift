//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class AWSRekognitionRule: @unchecked Sendable, Codable, JSONEncodable {
    /// What a moderation rule does when it matches.
    public var action: ModerationAction
    public var label: String
    public var minConfidence: Float

    public init(action: ModerationAction, label: String, minConfidence: Float) {
        self.action = action
        self.label = label
        self.minConfidence = minConfidence
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case action
        case label
        case minConfidence = "min_confidence"
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
