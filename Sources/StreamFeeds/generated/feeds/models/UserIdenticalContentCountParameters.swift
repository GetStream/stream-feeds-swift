//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UserIdenticalContentCountParameters: @unchecked Sendable, Codable, JSONEncodable {
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
}

extension UserIdenticalContentCountParameters: Hashable {
    public static func == (
        lhs: UserIdenticalContentCountParameters,
        rhs: UserIdenticalContentCountParameters
    ) -> Bool {
        lhs.threshold == rhs.threshold &&
            lhs.timeWindow == rhs.timeWindow
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(threshold)
        hasher.combine(timeWindow)
    }
}
