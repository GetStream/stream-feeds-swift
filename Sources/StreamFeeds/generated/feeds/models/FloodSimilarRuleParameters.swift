//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class FloodSimilarRuleParameters: Sendable, Codable, JSONEncodable {
    public let allowlist: [String]?
    public let minTextLength: Int?
    public let similarityDistance: Int?
    public let threshold: Int?
    public let timeWindow: String?

    public init(allowlist: [String]? = nil, minTextLength: Int? = nil, similarityDistance: Int? = nil, threshold: Int? = nil, timeWindow: String? = nil) {
        self.allowlist = allowlist
        self.minTextLength = minTextLength
        self.similarityDistance = similarityDistance
        self.threshold = threshold
        self.timeWindow = timeWindow
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.allowlist = try container.decodeIfPresent([String].self, forKey: .allowlist)
        self.minTextLength = try container.decodeIfPresent(Int.self, forKey: .minTextLength)
        self.similarityDistance = try container.decodeIfPresent(Int.self, forKey: .similarityDistance)
        self.threshold = try container.decodeIfPresent(Int.self, forKey: .threshold)
        self.timeWindow = try container.decodeIfPresent(String.self, forKey: .timeWindow)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(allowlist, forKey: .allowlist)
        try container.encodeIfPresent(minTextLength, forKey: .minTextLength)
        try container.encodeIfPresent(similarityDistance, forKey: .similarityDistance)
        try container.encodeIfPresent(threshold, forKey: .threshold)
        try container.encodeIfPresent(timeWindow, forKey: .timeWindow)
    }
}

extension FloodSimilarRuleParameters: Hashable {
    public static func == (lhs: FloodSimilarRuleParameters, rhs: FloodSimilarRuleParameters) -> Bool {
        lhs.allowlist == rhs.allowlist &&
            lhs.minTextLength == rhs.minTextLength &&
            lhs.similarityDistance == rhs.similarityDistance &&
            lhs.threshold == rhs.threshold &&
            lhs.timeWindow == rhs.timeWindow
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(allowlist)
        hasher.combine(minTextLength)
        hasher.combine(similarityDistance)
        hasher.combine(threshold)
        hasher.combine(timeWindow)
    }
}
