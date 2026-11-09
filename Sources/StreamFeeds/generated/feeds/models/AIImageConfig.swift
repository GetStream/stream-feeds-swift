//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class AIImageConfig: Sendable, Codable, JSONEncodable {
    public let async: Bool?
    public let enabled: Bool
    public let ocrRules: [OCRRule]
    public let ocrSeverityRules: [BodyguardRule]?
    public let rules: [AWSRekognitionRule]

    public init(async: Bool? = nil, enabled: Bool, ocrRules: [OCRRule], ocrSeverityRules: [BodyguardRule]? = nil, rules: [AWSRekognitionRule]) {
        self.async = async
        self.enabled = enabled
        self.ocrRules = ocrRules
        self.ocrSeverityRules = ocrSeverityRules
        self.rules = rules
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.async = try container.decodeIfPresent(Bool.self, forKey: .async)
        self.enabled = try container.decode(Bool.self, forKey: .enabled)
        self.ocrRules = try container.decode([OCRRule].self, forKey: .ocrRules)
        self.ocrSeverityRules = try container.decodeIfPresent([BodyguardRule].self, forKey: .ocrSeverityRules)
        self.rules = try container.decode([AWSRekognitionRule].self, forKey: .rules)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(async, forKey: .async)
        try container.encode(enabled, forKey: .enabled)
        try container.encode(ocrRules, forKey: .ocrRules)
        try container.encodeIfPresent(ocrSeverityRules, forKey: .ocrSeverityRules)
        try container.encode(rules, forKey: .rules)
    }
}

extension AIImageConfig: Hashable {
    public static func == (lhs: AIImageConfig, rhs: AIImageConfig) -> Bool {
        lhs.async == rhs.async &&
            lhs.enabled == rhs.enabled &&
            lhs.ocrRules == rhs.ocrRules &&
            lhs.ocrSeverityRules == rhs.ocrSeverityRules &&
            lhs.rules == rhs.rules
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(async)
        hasher.combine(enabled)
        hasher.combine(ocrRules)
        hasher.combine(ocrSeverityRules)
        hasher.combine(rules)
    }
}
