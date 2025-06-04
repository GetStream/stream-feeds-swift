import Foundation
import StreamCore

public final class AddReactionResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var activity: ActivityResponse
    public var duration: String
    public var reaction: FeedsReactionResponse

    public init(activity: ActivityResponse, duration: String, reaction: FeedsReactionResponse) {
        self.activity = activity
        self.duration = duration
        self.reaction = reaction
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case activity
        case duration
        case reaction
    }

    public static func == (lhs: AddReactionResponse, rhs: AddReactionResponse) -> Bool {
        lhs.activity == rhs.activity &&
            lhs.duration == rhs.duration &&
            lhs.reaction == rhs.reaction
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(activity)
        hasher.combine(duration)
        hasher.combine(reaction)
    }
}
