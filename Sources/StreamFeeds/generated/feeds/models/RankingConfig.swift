//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class RankingConfig: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var defaults: [String: RawJSON]?
    public var functions: [String: DecayFunctionConfig]?
    public var score: String?
    public var type: String?

    public init(defaults: [String: RawJSON]? = nil, functions: [String: DecayFunctionConfig]? = nil, score: String? = nil) {
        self.defaults = defaults
        self.functions = functions
        self.score = score
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case defaults
        case functions
        case score
        case type
    }

    public static func == (lhs: RankingConfig, rhs: RankingConfig) -> Bool {
        lhs.defaults == rhs.defaults &&
            lhs.functions == rhs.functions &&
            lhs.score == rhs.score &&
            lhs.type == rhs.type
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(defaults)
        hasher.combine(functions)
        hasher.combine(score)
        hasher.combine(type)
    }
}
