//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class AIImageConfig: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var async: Bool?
    public var enabled: Bool
    public var ocrRules: [OCRRule]
    public var rules: [AWSRekognitionRule]

    public init(async: Bool? = nil, enabled: Bool, ocrRules: [OCRRule], rules: [AWSRekognitionRule]) {
        self.async = async
        self.enabled = enabled
        self.ocrRules = ocrRules
        self.rules = rules
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case async
        case enabled
        case ocrRules = "ocr_rules"
        case rules
    }

    public static func == (lhs: AIImageConfig, rhs: AIImageConfig) -> Bool {
        lhs.async == rhs.async &&
            lhs.enabled == rhs.enabled &&
            lhs.ocrRules == rhs.ocrRules &&
            lhs.rules == rhs.rules
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(async)
        hasher.combine(enabled)
        hasher.combine(ocrRules)
        hasher.combine(rules)
    }
}
