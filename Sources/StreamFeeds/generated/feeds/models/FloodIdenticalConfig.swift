//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class FloodIdenticalConfig: @unchecked Sendable, Codable, JSONEncodable {
    public var action: String
    public var enabled: Bool
    public var threshold: Int
    public var timeWindow: String

    public init(action: String, enabled: Bool, threshold: Int, timeWindow: String) {
        self.action = action
        self.enabled = enabled
        self.threshold = threshold
        self.timeWindow = timeWindow
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case action
        case enabled
        case threshold
        case timeWindow = "time_window"
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
