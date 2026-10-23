//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class FloodSimilarConfig: @unchecked Sendable, Codable, JSONEncodable {
    public var action: String
    public var enabled: Bool
    public var similarityDistance: Int
    public var threshold: Int
    public var timeWindow: String

    public init(action: String, enabled: Bool, similarityDistance: Int, threshold: Int, timeWindow: String) {
        self.action = action
        self.enabled = enabled
        self.similarityDistance = similarityDistance
        self.threshold = threshold
        self.timeWindow = timeWindow
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case action
        case enabled
        case similarityDistance = "similarity_distance"
        case threshold
        case timeWindow = "time_window"
    }
}

extension FloodSimilarConfig: Hashable {
    public static func == (lhs: FloodSimilarConfig, rhs: FloodSimilarConfig) -> Bool {
        lhs.action == rhs.action &&
            lhs.enabled == rhs.enabled &&
            lhs.similarityDistance == rhs.similarityDistance &&
            lhs.threshold == rhs.threshold &&
            lhs.timeWindow == rhs.timeWindow
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(action)
        hasher.combine(enabled)
        hasher.combine(similarityDistance)
        hasher.combine(threshold)
        hasher.combine(timeWindow)
    }
}
