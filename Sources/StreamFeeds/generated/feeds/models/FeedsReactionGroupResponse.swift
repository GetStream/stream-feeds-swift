//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class FeedsReactionGroupResponse: Sendable, Codable, JSONEncodable {
    public let count: Int
    public let firstReactionAt: Date
    public let lastReactionAt: Date

    public init(count: Int, firstReactionAt: Date, lastReactionAt: Date) {
        self.count = count
        self.firstReactionAt = firstReactionAt
        self.lastReactionAt = lastReactionAt
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.count = try container.decode(Int.self, forKey: .count)
        self.firstReactionAt = try container.decode(Date.self, forKey: .firstReactionAt)
        self.lastReactionAt = try container.decode(Date.self, forKey: .lastReactionAt)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(count, forKey: .count)
        try container.encode(firstReactionAt, forKey: .firstReactionAt)
        try container.encode(lastReactionAt, forKey: .lastReactionAt)
    }
}

extension FeedsReactionGroupResponse: Hashable {
    public static func == (lhs: FeedsReactionGroupResponse, rhs: FeedsReactionGroupResponse) -> Bool {
        lhs.count == rhs.count &&
            lhs.firstReactionAt == rhs.firstReactionAt &&
            lhs.lastReactionAt == rhs.lastReactionAt
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(count)
        hasher.combine(firstReactionAt)
        hasher.combine(lastReactionAt)
    }
}
