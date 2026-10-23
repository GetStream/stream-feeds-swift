//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class IPFlagCountRuleParameters: Sendable, Codable, JSONEncodable {
    public let harmLabels: [String]?
    public let severity: String?
    public let threshold: Int?
    public let timeWindow: String?

    public init(harmLabels: [String]? = nil, severity: String? = nil, threshold: Int? = nil, timeWindow: String? = nil) {
        self.harmLabels = harmLabels
        self.severity = severity
        self.threshold = threshold
        self.timeWindow = timeWindow
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.harmLabels = try container.decodeIfPresent([String].self, forKey: .harmLabels)
        self.severity = try container.decodeIfPresent(String.self, forKey: .severity)
        self.threshold = try container.decodeIfPresent(Int.self, forKey: .threshold)
        self.timeWindow = try container.decodeIfPresent(String.self, forKey: .timeWindow)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(harmLabels, forKey: .harmLabels)
        try container.encodeIfPresent(severity, forKey: .severity)
        try container.encodeIfPresent(threshold, forKey: .threshold)
        try container.encodeIfPresent(timeWindow, forKey: .timeWindow)
    }
}

extension IPFlagCountRuleParameters: Hashable {
    public static func == (lhs: IPFlagCountRuleParameters, rhs: IPFlagCountRuleParameters) -> Bool {
        lhs.harmLabels == rhs.harmLabels &&
            lhs.severity == rhs.severity &&
            lhs.threshold == rhs.threshold &&
            lhs.timeWindow == rhs.timeWindow
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(harmLabels)
        hasher.combine(severity)
        hasher.combine(threshold)
        hasher.combine(timeWindow)
    }
}
