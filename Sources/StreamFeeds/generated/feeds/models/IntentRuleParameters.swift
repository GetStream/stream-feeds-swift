//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// intent_rule params: policy intent topic label and the minimum final score (1-100) that fires the condition
public final class IntentRuleParameters: @unchecked Sendable, Codable, JSONEncodable {
    public var threshold: Int?
    public var topic: String

    public init(threshold: Int? = nil, topic: String) {
        self.threshold = threshold
        self.topic = topic
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case threshold
        case topic
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
