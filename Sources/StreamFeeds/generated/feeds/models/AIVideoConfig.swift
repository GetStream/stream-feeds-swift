//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class AIVideoConfig: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var async: Bool?
    public var enabled: Bool
    public var rules: [AWSRekognitionRule]

    public init(async: Bool? = nil, enabled: Bool, rules: [AWSRekognitionRule]) {
        self.async = async
        self.enabled = enabled
        self.rules = rules
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case async
        case enabled
        case rules
    }

    public static func == (lhs: AIVideoConfig, rhs: AIVideoConfig) -> Bool {
        lhs.async == rhs.async &&
            lhs.enabled == rhs.enabled &&
            lhs.rules == rhs.rules
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(async)
        hasher.combine(enabled)
        hasher.combine(rules)
    }
}
