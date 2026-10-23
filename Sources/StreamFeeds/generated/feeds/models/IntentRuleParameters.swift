//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// intent_rule params: policy intent topic label and the minimum final score (1-100) that fires the condition
public final class IntentRuleParameters: Sendable, Codable, JSONEncodable {
    public let threshold: Int?
    public let topic: String

    public init(threshold: Int? = nil, topic: String) {
        self.threshold = threshold
        self.topic = topic
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.threshold = try container.decodeIfPresent(Int.self, forKey: .threshold)
        self.topic = try container.decode(String.self, forKey: .topic)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(threshold, forKey: .threshold)
        try container.encode(topic, forKey: .topic)
    }
}

extension IntentRuleParameters: Hashable {
    public static func == (lhs: IntentRuleParameters, rhs: IntentRuleParameters) -> Bool {
        lhs.threshold == rhs.threshold &&
            lhs.topic == rhs.topic
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(threshold)
        hasher.combine(topic)
    }
}
