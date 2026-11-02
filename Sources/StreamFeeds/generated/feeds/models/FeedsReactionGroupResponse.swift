//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class FeedsReactionGroupResponse: @unchecked Sendable, Codable, JSONEncodable {
    public var count: Int
    public var firstReactionAt: Date
    public var lastReactionAt: Date

    public init(count: Int, firstReactionAt: Date, lastReactionAt: Date) {
        self.count = count
        self.firstReactionAt = firstReactionAt
        self.lastReactionAt = lastReactionAt
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case count
        case firstReactionAt = "first_reaction_at"
        case lastReactionAt = "last_reaction_at"
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
