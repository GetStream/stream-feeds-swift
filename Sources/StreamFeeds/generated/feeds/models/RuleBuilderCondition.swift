//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class RuleBuilderCondition: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var labels: [String]?
    public var provider: String?
    public var threshold: Int?
    public var timeWindow: String?

    public init(labels: [String]? = nil, provider: String? = nil, threshold: Int? = nil, timeWindow: String? = nil) {
        self.labels = labels
        self.provider = provider
        self.threshold = threshold
        self.timeWindow = timeWindow
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case labels
        case provider
        case threshold
        case timeWindow = "time_window"
    }

    public static func == (lhs: RuleBuilderCondition, rhs: RuleBuilderCondition) -> Bool {
        lhs.labels == rhs.labels &&
            lhs.provider == rhs.provider &&
            lhs.threshold == rhs.threshold &&
            lhs.timeWindow == rhs.timeWindow
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(labels)
        hasher.combine(provider)
        hasher.combine(threshold)
        hasher.combine(timeWindow)
    }
}
