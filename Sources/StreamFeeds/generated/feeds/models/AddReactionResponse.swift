import Foundation
import StreamCore

public final class AddReactionResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var duration: String
    public var reaction: ActivityReaction

    public init(duration: String, reaction: ActivityReaction) {
        self.duration = duration
        self.reaction = reaction
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case duration
        case reaction
    }

    public static func == (lhs: AddReactionResponse, rhs: AddReactionResponse) -> Bool {
        lhs.duration == rhs.duration &&
            lhs.reaction == rhs.reaction
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(duration)
        hasher.combine(reaction)
    }
}
