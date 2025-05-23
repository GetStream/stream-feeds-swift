import Foundation
import StreamCore

public final class ReactionGroupResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
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

    public static func == (lhs: ReactionGroupResponse, rhs: ReactionGroupResponse) -> Bool {
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
