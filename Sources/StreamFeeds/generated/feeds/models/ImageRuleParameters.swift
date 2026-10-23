//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class ImageRuleParameters: Sendable, Codable, JSONEncodable {
    public let harmLabels: [String]?
    public let minConfidence: Double?
    public let threshold: Int?
    public let timeWindow: String?

    public init(harmLabels: [String]? = nil, minConfidence: Double? = nil, threshold: Int? = nil, timeWindow: String? = nil) {
        self.harmLabels = harmLabels
        self.minConfidence = minConfidence
        self.threshold = threshold
        self.timeWindow = timeWindow
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.harmLabels = try container.decodeIfPresent([String].self, forKey: .harmLabels)
        self.minConfidence = try container.decodeIfPresent(Double.self, forKey: .minConfidence)
        self.threshold = try container.decodeIfPresent(Int.self, forKey: .threshold)
        self.timeWindow = try container.decodeIfPresent(String.self, forKey: .timeWindow)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(harmLabels, forKey: .harmLabels)
        try container.encodeIfPresent(minConfidence, forKey: .minConfidence)
        try container.encodeIfPresent(threshold, forKey: .threshold)
        try container.encodeIfPresent(timeWindow, forKey: .timeWindow)
    }
}

extension ImageRuleParameters: Hashable {
    public static func == (lhs: ImageRuleParameters, rhs: ImageRuleParameters) -> Bool {
        lhs.harmLabels == rhs.harmLabels &&
            lhs.minConfidence == rhs.minConfidence &&
            lhs.threshold == rhs.threshold &&
            lhs.timeWindow == rhs.timeWindow
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(harmLabels)
        hasher.combine(minConfidence)
        hasher.combine(threshold)
        hasher.combine(timeWindow)
    }
}
