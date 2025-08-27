//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class ContentCountRuleParameters: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var threshold: Int?
    public var timeWindow: String?

    public init(threshold: Int? = nil, timeWindow: String? = nil) {
        self.threshold = threshold
        self.timeWindow = timeWindow
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case threshold
        case timeWindow = "time_window"
    }

    public static func == (lhs: ContentCountRuleParameters, rhs: ContentCountRuleParameters) -> Bool {
        lhs.threshold == rhs.threshold &&
            lhs.timeWindow == rhs.timeWindow
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(threshold)
        hasher.combine(timeWindow)
    }
}
