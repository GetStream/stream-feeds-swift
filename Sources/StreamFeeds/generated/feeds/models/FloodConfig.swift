//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class FloodConfig: @unchecked Sendable, Codable, JSONEncodable {
    public var allowlist: [String]?
    public var identical: FloodIdenticalConfig?
    public var similar: FloodSimilarConfig?

    public init(
        allowlist: [String]? = nil,
        identical: FloodIdenticalConfig? = nil,
        similar: FloodSimilarConfig? = nil
    ) {
        self.allowlist = allowlist
        self.identical = identical
        self.similar = similar
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case allowlist
        case identical
        case similar
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
