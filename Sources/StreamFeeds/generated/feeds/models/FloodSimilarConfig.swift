//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class FloodSimilarConfig: Sendable, Codable, JSONEncodable {
    public let action: String
    public let enabled: Bool
    public let similarityDistance: Int
    public let threshold: Int
    public let timeWindow: String

    public init(action: String, enabled: Bool, similarityDistance: Int, threshold: Int, timeWindow: String) {
        self.action = action
        self.enabled = enabled
        self.similarityDistance = similarityDistance
        self.threshold = threshold
        self.timeWindow = timeWindow
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.action = try container.decode(String.self, forKey: .action)
        self.enabled = try container.decode(Bool.self, forKey: .enabled)
        self.similarityDistance = try container.decode(Int.self, forKey: .similarityDistance)
        self.threshold = try container.decode(Int.self, forKey: .threshold)
        self.timeWindow = try container.decode(String.self, forKey: .timeWindow)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(action, forKey: .action)
        try container.encode(enabled, forKey: .enabled)
        try container.encode(similarityDistance, forKey: .similarityDistance)
        try container.encode(threshold, forKey: .threshold)
        try container.encode(timeWindow, forKey: .timeWindow)
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
