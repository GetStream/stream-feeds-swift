import Foundation
import StreamCore

public final class AddCommentReactionResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var comment: CommentResponse
    public var duration: String
    public var reaction: FeedsReactionResponse

    public init(comment: CommentResponse, duration: String, reaction: FeedsReactionResponse) {
        self.comment = comment
        self.duration = duration
        self.reaction = reaction
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case comment
        case duration
        case reaction
    }

    public static func == (lhs: AddCommentReactionResponse, rhs: AddCommentReactionResponse) -> Bool {
        lhs.comment == rhs.comment &&
            lhs.duration == rhs.duration &&
            lhs.reaction == rhs.reaction
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(comment)
        hasher.combine(duration)
        hasher.combine(reaction)
    }
}
