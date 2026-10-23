//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class FloodSimilarRuleParameters: @unchecked Sendable, Codable, JSONEncodable {
    public var allowlist: [String]?
    public var minTextLength: Int?
    public var similarityDistance: Int?
    public var threshold: Int?
    public var timeWindow: String?

    public init(
        allowlist: [String]? = nil,
        minTextLength: Int? = nil,
        similarityDistance: Int? = nil,
        threshold: Int? = nil,
        timeWindow: String? = nil
    ) {
        self.allowlist = allowlist
        self.minTextLength = minTextLength
        self.similarityDistance = similarityDistance
        self.threshold = threshold
        self.timeWindow = timeWindow
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case allowlist
        case minTextLength = "min_text_length"
        case similarityDistance = "similarity_distance"
        case threshold
        case timeWindow = "time_window"
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
