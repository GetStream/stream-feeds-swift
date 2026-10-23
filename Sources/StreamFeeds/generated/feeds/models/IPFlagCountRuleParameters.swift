//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class IPFlagCountRuleParameters: @unchecked Sendable, Codable, JSONEncodable {
    public var harmLabels: [String]?
    public var severity: String?
    public var threshold: Int?
    public var timeWindow: String?

    public init(
        harmLabels: [String]? = nil,
        severity: String? = nil,
        threshold: Int? = nil,
        timeWindow: String? = nil
    ) {
        self.harmLabels = harmLabels
        self.severity = severity
        self.threshold = threshold
        self.timeWindow = timeWindow
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case harmLabels = "harm_labels"
        case severity
        case threshold
        case timeWindow = "time_window"
    }
}

extension IPFlagCountRuleParameters: Hashable {
    public static func == (lhs: IPFlagCountRuleParameters, rhs: IPFlagCountRuleParameters) -> Bool {
        lhs.harmLabels == rhs.harmLabels &&
            lhs.severity == rhs.severity &&
            lhs.threshold == rhs.threshold &&
            lhs.timeWindow == rhs.timeWindow
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(harmLabels)
        hasher.combine(severity)
        hasher.combine(threshold)
        hasher.combine(timeWindow)
    }
}
