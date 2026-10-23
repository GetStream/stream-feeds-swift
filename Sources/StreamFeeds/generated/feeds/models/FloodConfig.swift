//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class FloodConfig: Sendable, Codable, JSONEncodable {
    public let allowlist: [String]?
    public let identical: FloodIdenticalConfig?
    public let similar: FloodSimilarConfig?

    public init(allowlist: [String]? = nil, identical: FloodIdenticalConfig? = nil, similar: FloodSimilarConfig? = nil) {
        self.allowlist = allowlist
        self.identical = identical
        self.similar = similar
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.allowlist = try container.decodeIfPresent([String].self, forKey: .allowlist)
        self.identical = try container.decodeIfPresent(FloodIdenticalConfig.self, forKey: .identical)
        self.similar = try container.decodeIfPresent(FloodSimilarConfig.self, forKey: .similar)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(allowlist, forKey: .allowlist)
        try container.encodeIfPresent(identical, forKey: .identical)
        try container.encodeIfPresent(similar, forKey: .similar)
    }
}

extension FloodConfig: Hashable {
    public static func == (lhs: FloodConfig, rhs: FloodConfig) -> Bool {
        lhs.allowlist == rhs.allowlist &&
            lhs.identical == rhs.identical &&
            lhs.similar == rhs.similar
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(allowlist)
        hasher.combine(identical)
        hasher.combine(similar)
    }
}
