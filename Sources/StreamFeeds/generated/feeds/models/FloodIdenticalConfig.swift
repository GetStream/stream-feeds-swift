//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class FloodIdenticalConfig: Sendable, Codable, JSONEncodable {
    public let action: String
    public let enabled: Bool
    public let threshold: Int
    public let timeWindow: String

    public init(action: String, enabled: Bool, threshold: Int, timeWindow: String) {
        self.action = action
        self.enabled = enabled
        self.threshold = threshold
        self.timeWindow = timeWindow
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.action = try container.decode(String.self, forKey: .action)
        self.enabled = try container.decode(Bool.self, forKey: .enabled)
        self.threshold = try container.decode(Int.self, forKey: .threshold)
        self.timeWindow = try container.decode(String.self, forKey: .timeWindow)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(action, forKey: .action)
        try container.encode(enabled, forKey: .enabled)
        try container.encode(threshold, forKey: .threshold)
        try container.encode(timeWindow, forKey: .timeWindow)
    }
}

extension FloodIdenticalConfig: Hashable {
    public static func == (lhs: FloodIdenticalConfig, rhs: FloodIdenticalConfig) -> Bool {
        lhs.action == rhs.action &&
            lhs.enabled == rhs.enabled &&
            lhs.threshold == rhs.threshold &&
            lhs.timeWindow == rhs.timeWindow
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(action)
        hasher.combine(enabled)
        hasher.combine(threshold)
        hasher.combine(timeWindow)
    }
}
