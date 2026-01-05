//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class TextContentParameters: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var blocklistMatch: [String]?
    public var containsUrl: Bool?
    public var harmLabels: [String]?
    public var llmHarmLabels: [String: String]?
    public var severity: String?

    public init(blocklistMatch: [String]? = nil, containsUrl: Bool? = nil, harmLabels: [String]? = nil, llmHarmLabels: [String: String]? = nil, severity: String? = nil) {
        self.blocklistMatch = blocklistMatch
        self.containsUrl = containsUrl
        self.harmLabels = harmLabels
        self.llmHarmLabels = llmHarmLabels
        self.severity = severity
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case blocklistMatch = "blocklist_match"
        case containsUrl = "contains_url"
        case harmLabels = "harm_labels"
        case llmHarmLabels = "llm_harm_labels"
        case severity
    }

    public static func == (lhs: TextContentParameters, rhs: TextContentParameters) -> Bool {
        lhs.blocklistMatch == rhs.blocklistMatch &&
            lhs.containsUrl == rhs.containsUrl &&
            lhs.harmLabels == rhs.harmLabels &&
            lhs.llmHarmLabels == rhs.llmHarmLabels &&
            lhs.severity == rhs.severity
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(blocklistMatch)
        hasher.combine(containsUrl)
        hasher.combine(harmLabels)
        hasher.combine(llmHarmLabels)
        hasher.combine(severity)
    }
}
