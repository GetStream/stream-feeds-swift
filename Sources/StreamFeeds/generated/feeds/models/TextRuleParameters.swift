//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class TextRuleParameters: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var blocklistMatch: [String]?
    public var containsUrl: Bool?
    public var harmLabels: [String]?
    public var llmHarmLabels: [String: String]?
    public var severity: String?
    public var threshold: Int?
    public var timeWindow: String?

    public init(blocklistMatch: [String]? = nil, containsUrl: Bool? = nil, harmLabels: [String]? = nil, llmHarmLabels: [String: String]? = nil, severity: String? = nil, threshold: Int? = nil, timeWindow: String? = nil) {
        self.blocklistMatch = blocklistMatch
        self.containsUrl = containsUrl
        self.harmLabels = harmLabels
        self.llmHarmLabels = llmHarmLabels
        self.severity = severity
        self.threshold = threshold
        self.timeWindow = timeWindow
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case blocklistMatch = "blocklist_match"
        case containsUrl = "contains_url"
        case harmLabels = "harm_labels"
        case llmHarmLabels = "llm_harm_labels"
        case severity
        case threshold
        case timeWindow = "time_window"
    }

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
