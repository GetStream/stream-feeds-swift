//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class FlagCountRuleParameters: Sendable, Codable, JSONEncodable {
    public let threshold: Int?

    public init(threshold: Int? = nil) {
        self.threshold = threshold
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.threshold = try container.decodeIfPresent(Int.self, forKey: .threshold)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(threshold, forKey: .threshold)
    }
}

extension FlagCountRuleParameters: Hashable {
    public static func == (lhs: FlagCountRuleParameters, rhs: FlagCountRuleParameters) -> Bool {
        lhs.threshold == rhs.threshold
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(threshold)
    }
}
