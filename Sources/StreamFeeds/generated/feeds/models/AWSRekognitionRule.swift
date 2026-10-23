//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class AWSRekognitionRule: @unchecked Sendable, Codable, JSONEncodable {
    public enum AWSRekognitionRuleAction: String, Sendable, Codable, CaseIterable {
        case bounce
        case bounceFlag = "bounce_flag"
        case bounceRemove = "bounce_remove"
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

    public var action: AWSRekognitionRuleAction
    public var label: String
    public var minConfidence: Float
    public var subclassifications: [String: RawJSON]?

    public init(
        action: AWSRekognitionRuleAction,
        label: String,
        minConfidence: Float,
        subclassifications: [String: RawJSON]? = nil
    ) {
        self.action = action
        self.label = label
        self.minConfidence = minConfidence
        self.subclassifications = subclassifications
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case action
        case label
        case minConfidence = "min_confidence"
        case subclassifications
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
