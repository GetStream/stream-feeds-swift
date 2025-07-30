//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class VideoRuleParameters: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var harmLabels: [String]?
    public var threshold: Int
    public var timeWindow: String

    public init(harmLabels: [String]? = nil, threshold: Int, timeWindow: String) {
        self.harmLabels = harmLabels
        self.threshold = threshold
        self.timeWindow = timeWindow
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case harmLabels = "harm_labels"
        case threshold
        case timeWindow = "time_window"
    }

    public static func == (lhs: VideoRuleParameters, rhs: VideoRuleParameters) -> Bool {
        lhs.harmLabels == rhs.harmLabels &&
            lhs.threshold == rhs.threshold &&
            lhs.timeWindow == rhs.timeWindow
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(harmLabels)
        hasher.combine(threshold)
        hasher.combine(timeWindow)
    }
}
