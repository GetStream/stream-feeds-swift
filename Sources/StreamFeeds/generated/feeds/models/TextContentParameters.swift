//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class TextContentParameters: Sendable, Codable, JSONEncodable {
    public let blocklistMatch: [String]?
    public let containsUrl: Bool?
    public let harmLabels: [String]?
    public let llmHarmLabels: [String: String]?
    public let severity: String?

    public init(blocklistMatch: [String]? = nil, containsUrl: Bool? = nil, harmLabels: [String]? = nil, llmHarmLabels: [String: String]? = nil, severity: String? = nil) {
        self.blocklistMatch = blocklistMatch
        self.containsUrl = containsUrl
        self.harmLabels = harmLabels
        self.llmHarmLabels = llmHarmLabels
        self.severity = severity
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.blocklistMatch = try container.decodeIfPresent([String].self, forKey: .blocklistMatch)
        self.containsUrl = try container.decodeIfPresent(Bool.self, forKey: .containsUrl)
        self.harmLabels = try container.decodeIfPresent([String].self, forKey: .harmLabels)
        self.llmHarmLabels = try container.decodeIfPresent([String: String].self, forKey: .llmHarmLabels)
        self.severity = try container.decodeIfPresent(String.self, forKey: .severity)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(blocklistMatch, forKey: .blocklistMatch)
        try container.encodeIfPresent(containsUrl, forKey: .containsUrl)
        try container.encodeIfPresent(harmLabels, forKey: .harmLabels)
        try container.encodeIfPresent(llmHarmLabels, forKey: .llmHarmLabels)
        try container.encodeIfPresent(severity, forKey: .severity)
    }
}

extension TextContentParameters: Hashable {
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
