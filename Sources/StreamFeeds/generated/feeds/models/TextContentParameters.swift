//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class TextContentParameters: @unchecked Sendable, Codable, JSONEncodable {
    public var blocklistMatch: [String]?
    public var containsUrl: Bool?
    public var harmLabels: [String]?
    public var labelOperator: String?
    public var llmHarmLabels: [String: String]?
    public var severity: String?
    public var textLength: Int?
    public var textLengthOperator: String?

    public init(
        blocklistMatch: [String]? = nil,
        containsUrl: Bool? = nil,
        harmLabels: [String]? = nil,
        labelOperator: String? = nil,
        llmHarmLabels: [String: String]? = nil,
        severity: String? = nil,
        textLength: Int? = nil,
        textLengthOperator: String? = nil
    ) {
        self.blocklistMatch = blocklistMatch
        self.containsUrl = containsUrl
        self.harmLabels = harmLabels
        self.labelOperator = labelOperator
        self.llmHarmLabels = llmHarmLabels
        self.severity = severity
        self.textLength = textLength
        self.textLengthOperator = textLengthOperator
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case blocklistMatch = "blocklist_match"
        case containsUrl = "contains_url"
        case harmLabels = "harm_labels"
        case labelOperator = "label_operator"
        case llmHarmLabels = "llm_harm_labels"
        case severity
        case textLength = "text_length"
        case textLengthOperator = "text_length_operator"
    }
}

extension TextContentParameters: Hashable {
    public static func == (lhs: TextContentParameters, rhs: TextContentParameters) -> Bool {
        lhs.blocklistMatch == rhs.blocklistMatch &&
            lhs.containsUrl == rhs.containsUrl &&
            lhs.harmLabels == rhs.harmLabels &&
            lhs.labelOperator == rhs.labelOperator &&
            lhs.llmHarmLabels == rhs.llmHarmLabels &&
            lhs.severity == rhs.severity &&
            lhs.textLength == rhs.textLength &&
            lhs.textLengthOperator == rhs.textLengthOperator
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(blocklistMatch)
        hasher.combine(containsUrl)
        hasher.combine(harmLabels)
        hasher.combine(labelOperator)
        hasher.combine(llmHarmLabels)
        hasher.combine(severity)
        hasher.combine(textLength)
        hasher.combine(textLengthOperator)
    }
}
