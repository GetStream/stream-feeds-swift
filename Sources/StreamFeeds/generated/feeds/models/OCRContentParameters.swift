//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class OCRContentParameters: Sendable, Codable, JSONEncodable {
    public let harmLabels: [String]?
    public let labelOperator: String?
    public let severity: String?

    public init(harmLabels: [String]? = nil, labelOperator: String? = nil, severity: String? = nil) {
        self.harmLabels = harmLabels
        self.labelOperator = labelOperator
        self.severity = severity
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.harmLabels = try container.decodeIfPresent([String].self, forKey: .harmLabels)
        self.labelOperator = try container.decodeIfPresent(String.self, forKey: .labelOperator)
        self.severity = try container.decodeIfPresent(String.self, forKey: .severity)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(harmLabels, forKey: .harmLabels)
        try container.encodeIfPresent(labelOperator, forKey: .labelOperator)
        try container.encodeIfPresent(severity, forKey: .severity)
    }
}

extension OCRContentParameters: Hashable {
    public static func == (lhs: OCRContentParameters, rhs: OCRContentParameters) -> Bool {
        lhs.harmLabels == rhs.harmLabels &&
            lhs.labelOperator == rhs.labelOperator &&
            lhs.severity == rhs.severity
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(harmLabels)
        hasher.combine(labelOperator)
        hasher.combine(severity)
    }
}
