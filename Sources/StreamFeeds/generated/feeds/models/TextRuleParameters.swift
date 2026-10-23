//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class TextRuleParameters: Sendable, Codable, JSONEncodable {
    public let blocklistMatch: [String]?
    public let containsUrl: Bool?
    public let harmLabels: [String]?
    public let llmHarmLabels: [String: String]?
    public let semanticFilterMinThreshold: Double?
    public let semanticFilterNames: [String]?
    public let severity: String?
    public let threshold: Int?
    public let timeWindow: String?

    public init(blocklistMatch: [String]? = nil, containsUrl: Bool? = nil, harmLabels: [String]? = nil, llmHarmLabels: [String: String]? = nil, semanticFilterMinThreshold: Double? = nil, semanticFilterNames: [String]? = nil, severity: String? = nil, threshold: Int? = nil, timeWindow: String? = nil) {
        self.blocklistMatch = blocklistMatch
        self.containsUrl = containsUrl
        self.harmLabels = harmLabels
        self.llmHarmLabels = llmHarmLabels
        self.semanticFilterMinThreshold = semanticFilterMinThreshold
        self.semanticFilterNames = semanticFilterNames
        self.severity = severity
        self.threshold = threshold
        self.timeWindow = timeWindow
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.blocklistMatch = try container.decodeIfPresent([String].self, forKey: .blocklistMatch)
        self.containsUrl = try container.decodeIfPresent(Bool.self, forKey: .containsUrl)
        self.harmLabels = try container.decodeIfPresent([String].self, forKey: .harmLabels)
        self.llmHarmLabels = try container.decodeIfPresent([String: String].self, forKey: .llmHarmLabels)
        self.semanticFilterMinThreshold = try container.decodeIfPresent(Double.self, forKey: .semanticFilterMinThreshold)
        self.semanticFilterNames = try container.decodeIfPresent([String].self, forKey: .semanticFilterNames)
        self.severity = try container.decodeIfPresent(String.self, forKey: .severity)
        self.threshold = try container.decodeIfPresent(Int.self, forKey: .threshold)
        self.timeWindow = try container.decodeIfPresent(String.self, forKey: .timeWindow)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(blocklistMatch, forKey: .blocklistMatch)
        try container.encodeIfPresent(containsUrl, forKey: .containsUrl)
        try container.encodeIfPresent(harmLabels, forKey: .harmLabels)
        try container.encodeIfPresent(llmHarmLabels, forKey: .llmHarmLabels)
        try container.encodeIfPresent(semanticFilterMinThreshold, forKey: .semanticFilterMinThreshold)
        try container.encodeIfPresent(semanticFilterNames, forKey: .semanticFilterNames)
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
            lhs.semanticFilterMinThreshold == rhs.semanticFilterMinThreshold &&
            lhs.semanticFilterNames == rhs.semanticFilterNames &&
            lhs.severity == rhs.severity &&
            lhs.threshold == rhs.threshold &&
            lhs.timeWindow == rhs.timeWindow
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(blocklistMatch)
        hasher.combine(containsUrl)
        hasher.combine(harmLabels)
        hasher.combine(llmHarmLabels)
        hasher.combine(semanticFilterMinThreshold)
        hasher.combine(semanticFilterNames)
        hasher.combine(severity)
        hasher.combine(threshold)
        hasher.combine(timeWindow)
    }
}
