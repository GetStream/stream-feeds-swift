//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class BlockListConfig: @unchecked Sendable, Codable, JSONEncodable {
    public var async: Bool?
    public var enabled: Bool
    public var matchSubstring: Bool?
    public var rules: [BlockListRule]

    public init(
        async: Bool? = nil,
        enabled: Bool,
        matchSubstring: Bool? = nil,
        rules: [BlockListRule]
    ) {
        self.async = async
        self.enabled = enabled
        self.matchSubstring = matchSubstring
        self.rules = rules
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case async
        case enabled
        case matchSubstring = "match_substring"
        case rules
    }
}

extension BlockListConfig: Hashable {
    public static func == (lhs: BlockListConfig, rhs: BlockListConfig) -> Bool {
        lhs.async == rhs.async &&
            lhs.enabled == rhs.enabled &&
            lhs.matchSubstring == rhs.matchSubstring &&
            lhs.rules == rhs.rules
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(async)
        hasher.combine(enabled)
        hasher.combine(matchSubstring)
        hasher.combine(rules)
    }
}
