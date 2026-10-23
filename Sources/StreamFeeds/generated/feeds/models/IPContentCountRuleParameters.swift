//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class IPContentCountRuleParameters: Sendable, Codable, JSONEncodable {
    public let threshold: Int?
    public let timeWindow: String?

    public init(threshold: Int? = nil, timeWindow: String? = nil) {
        self.threshold = threshold
        self.timeWindow = timeWindow
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.threshold = try container.decodeIfPresent(Int.self, forKey: .threshold)
        self.timeWindow = try container.decodeIfPresent(String.self, forKey: .timeWindow)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(threshold, forKey: .threshold)
        try container.encodeIfPresent(timeWindow, forKey: .timeWindow)
    }
}

extension IPContentCountRuleParameters: Hashable {
    public static func == (lhs: IPContentCountRuleParameters, rhs: IPContentCountRuleParameters) -> Bool {
        lhs.threshold == rhs.threshold &&
            lhs.timeWindow == rhs.timeWindow
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(threshold)
        hasher.combine(timeWindow)
    }
}
