//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class FloodIdenticalRuleParameters: Sendable, Codable, JSONEncodable {
    public let allowlist: [String]?
    public let minTextLength: Int?
    public let threshold: Int?
    public let timeWindow: String?
    public let trackAcrossUsers: Bool?

    public init(allowlist: [String]? = nil, minTextLength: Int? = nil, threshold: Int? = nil, timeWindow: String? = nil, trackAcrossUsers: Bool? = nil) {
        self.allowlist = allowlist
        self.minTextLength = minTextLength
        self.threshold = threshold
        self.timeWindow = timeWindow
        self.trackAcrossUsers = trackAcrossUsers
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.allowlist = try container.decodeIfPresent([String].self, forKey: .allowlist)
        self.minTextLength = try container.decodeIfPresent(Int.self, forKey: .minTextLength)
        self.threshold = try container.decodeIfPresent(Int.self, forKey: .threshold)
        self.timeWindow = try container.decodeIfPresent(String.self, forKey: .timeWindow)
        self.trackAcrossUsers = try container.decodeIfPresent(Bool.self, forKey: .trackAcrossUsers)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(allowlist, forKey: .allowlist)
        try container.encodeIfPresent(minTextLength, forKey: .minTextLength)
        try container.encodeIfPresent(threshold, forKey: .threshold)
        try container.encodeIfPresent(timeWindow, forKey: .timeWindow)
        try container.encodeIfPresent(trackAcrossUsers, forKey: .trackAcrossUsers)
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
