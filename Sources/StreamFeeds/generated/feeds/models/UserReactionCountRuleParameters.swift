//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UserReactionCountRuleParameters: @unchecked Sendable, Codable, JSONEncodable {
    public var count: String?
    public var threshold: Int?
    public var timeWindow: String?

    public init(count: String? = nil, threshold: Int? = nil, timeWindow: String? = nil) {
        self.count = count
        self.threshold = threshold
        self.timeWindow = timeWindow
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case count
        case threshold
        case timeWindow = "time_window"
    }
}

extension UserReactionCountRuleParameters: Hashable {
    public static func == (
        lhs: UserReactionCountRuleParameters,
        rhs: UserReactionCountRuleParameters
    ) -> Bool {
        lhs.count == rhs.count &&
            lhs.threshold == rhs.threshold &&
            lhs.timeWindow == rhs.timeWindow
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(count)
        hasher.combine(threshold)
        hasher.combine(timeWindow)
    }
}
