//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UserIdenticalImageCountParameters: @unchecked Sendable, Codable, JSONEncodable {
    public var match: String?
    public var similarityDistance: Int?
    public var threshold: Int?
    public var timeWindow: String?

    public init(
        match: String? = nil,
        similarityDistance: Int? = nil,
        threshold: Int? = nil,
        timeWindow: String? = nil
    ) {
        self.match = match
        self.similarityDistance = similarityDistance
        self.threshold = threshold
        self.timeWindow = timeWindow
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case match
        case similarityDistance = "similarity_distance"
        case threshold
        case timeWindow = "time_window"
    }
}

extension UserIdenticalImageCountParameters: Hashable {
    public static func == (
        lhs: UserIdenticalImageCountParameters,
        rhs: UserIdenticalImageCountParameters
    ) -> Bool {
        lhs.match == rhs.match &&
            lhs.similarityDistance == rhs.similarityDistance &&
            lhs.threshold == rhs.threshold &&
            lhs.timeWindow == rhs.timeWindow
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(match)
        hasher.combine(similarityDistance)
        hasher.combine(threshold)
        hasher.combine(timeWindow)
    }
}
