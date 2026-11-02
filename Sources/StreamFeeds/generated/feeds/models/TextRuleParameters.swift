//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class TextRuleParameters: Sendable, Encodable, JSONEncodable {
    public let blocklistMatch: [String]?
    public let containsUrl: Bool?
    public let harmLabels: [String]?
    public let llmHarmLabels: [String: String]?
    public let severity: String?
    public let threshold: Int?
    public let timeWindow: String?

    public init(blocklistMatch: [String]? = nil, containsUrl: Bool? = nil, harmLabels: [String]? = nil, llmHarmLabels: [String: String]? = nil, severity: String? = nil, threshold: Int? = nil, timeWindow: String? = nil) {
        self.blocklistMatch = blocklistMatch
        self.containsUrl = containsUrl
        self.harmLabels = harmLabels
        self.llmHarmLabels = llmHarmLabels
        self.severity = severity
        self.threshold = threshold
        self.timeWindow = timeWindow
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(blocklistMatch, forKey: .blocklistMatch)
        try container.encodeIfPresent(containsUrl, forKey: .containsUrl)
        try container.encodeIfPresent(harmLabels, forKey: .harmLabels)
        try container.encodeIfPresent(llmHarmLabels, forKey: .llmHarmLabels)
        try container.encodeIfPresent(severity, forKey: .severity)
        try container.encodeIfPresent(threshold, forKey: .threshold)
        try container.encodeIfPresent(timeWindow, forKey: .timeWindow)
    }
}

extension TextRuleParameters: Hashable {
    public static func == (lhs: TextRuleParameters, rhs: TextRuleParameters) -> Bool {
        lhs.blocklistMatch == rhs.blocklistMatch &&
            lhs.containsUrl == rhs.containsUrl &&
            lhs.harmLabels == rhs.harmLabels &&
            lhs.llmHarmLabels == rhs.llmHarmLabels &&
            lhs.severity == rhs.severity &&
            lhs.threshold == rhs.threshold &&
            lhs.timeWindow == rhs.timeWindow
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(blocklistMatch)
        hasher.combine(containsUrl)
        hasher.combine(harmLabels)
        hasher.combine(llmHarmLabels)
        hasher.combine(severity)
        hasher.combine(threshold)
        hasher.combine(timeWindow)
    }
}
