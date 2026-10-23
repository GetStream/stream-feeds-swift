//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UserReactionCountRuleParameters: Sendable, Codable, JSONEncodable {
    public let count: String?
    public let threshold: Int?
    public let timeWindow: String?

    public init(count: String? = nil, threshold: Int? = nil, timeWindow: String? = nil) {
        self.count = count
        self.threshold = threshold
        self.timeWindow = timeWindow
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.count = try container.decodeIfPresent(String.self, forKey: .count)
        self.threshold = try container.decodeIfPresent(Int.self, forKey: .threshold)
        self.timeWindow = try container.decodeIfPresent(String.self, forKey: .timeWindow)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(count, forKey: .count)
        try container.encodeIfPresent(threshold, forKey: .threshold)
        try container.encodeIfPresent(timeWindow, forKey: .timeWindow)
    }
}

extension UserReactionCountRuleParameters: Hashable {
    public static func == (lhs: UserReactionCountRuleParameters, rhs: UserReactionCountRuleParameters) -> Bool {
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
