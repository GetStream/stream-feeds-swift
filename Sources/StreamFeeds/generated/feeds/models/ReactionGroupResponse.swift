//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class ReactionGroupResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var count: Int
    public var firstReactionAt: Date
    public var lastReactionAt: Date
    public var sumScores: Int?

    public init(count: Int, firstReactionAt: Date, lastReactionAt: Date, sumScores: Int?) {
        self.count = count
        self.firstReactionAt = firstReactionAt
        self.lastReactionAt = lastReactionAt
        self.sumScores = sumScores
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case count
        case firstReactionAt = "first_reaction_at"
        case lastReactionAt = "last_reaction_at"
        case sumScores = "sum_scores"
    }

    public static func == (lhs: ReactionGroupResponse, rhs: ReactionGroupResponse) -> Bool {
        lhs.count == rhs.count &&
            lhs.firstReactionAt == rhs.firstReactionAt &&
            lhs.lastReactionAt == rhs.lastReactionAt &&
            lhs.sumScores == rhs.sumScores
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(count)
        hasher.combine(firstReactionAt)
        hasher.combine(lastReactionAt)
        hasher.combine(sumScores)
    }
}
