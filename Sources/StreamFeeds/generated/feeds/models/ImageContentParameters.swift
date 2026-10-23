//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class ImageContentParameters: Sendable, Codable, JSONEncodable {
    public let harmLabels: [String]?
    public let labelOperator: String?
    public let minConfidence: Double?

    public init(harmLabels: [String]? = nil, labelOperator: String? = nil, minConfidence: Double? = nil) {
        self.harmLabels = harmLabels
        self.labelOperator = labelOperator
        self.minConfidence = minConfidence
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.harmLabels = try container.decodeIfPresent([String].self, forKey: .harmLabels)
        self.labelOperator = try container.decodeIfPresent(String.self, forKey: .labelOperator)
        self.minConfidence = try container.decodeIfPresent(Double.self, forKey: .minConfidence)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(harmLabels, forKey: .harmLabels)
        try container.encodeIfPresent(labelOperator, forKey: .labelOperator)
        try container.encodeIfPresent(minConfidence, forKey: .minConfidence)
    }
}

extension ImageContentParameters: Hashable {
    public static func == (lhs: ImageContentParameters, rhs: ImageContentParameters) -> Bool {
        lhs.harmLabels == rhs.harmLabels &&
            lhs.labelOperator == rhs.labelOperator &&
            lhs.minConfidence == rhs.minConfidence
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(harmLabels)
        hasher.combine(labelOperator)
        hasher.combine(minConfidence)
    }
}
