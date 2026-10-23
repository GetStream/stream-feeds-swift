//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class FloodIdenticalRuleParameters: @unchecked Sendable, Codable, JSONEncodable {
    public var allowlist: [String]?
    public var minTextLength: Int?
    public var threshold: Int?
    public var timeWindow: String?
    public var trackAcrossUsers: Bool?

    public init(allowlist: [String]? = nil, minTextLength: Int? = nil, threshold: Int? = nil, timeWindow: String? = nil, trackAcrossUsers: Bool? = nil) {
        self.allowlist = allowlist
        self.minTextLength = minTextLength
        self.threshold = threshold
        self.timeWindow = timeWindow
        self.trackAcrossUsers = trackAcrossUsers
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case allowlist
        case minTextLength = "min_text_length"
        case threshold
        case timeWindow = "time_window"
        case trackAcrossUsers = "track_across_users"
    }
}

extension FloodIdenticalRuleParameters: Hashable {
    public static func == (lhs: FloodIdenticalRuleParameters, rhs: FloodIdenticalRuleParameters) -> Bool {
        lhs.allowlist == rhs.allowlist &&
            lhs.minTextLength == rhs.minTextLength &&
            lhs.threshold == rhs.threshold &&
            lhs.timeWindow == rhs.timeWindow &&
            lhs.trackAcrossUsers == rhs.trackAcrossUsers
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(allowlist)
        hasher.combine(minTextLength)
        hasher.combine(threshold)
        hasher.combine(timeWindow)
        hasher.combine(trackAcrossUsers)
    }
}
