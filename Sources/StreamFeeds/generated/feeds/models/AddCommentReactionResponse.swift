import Foundation
import StreamCore

public final class AddCommentReactionResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var commentId: String
    public var duration: String
    public var reaction: ActivityReactionResponse

    public init(commentId: String, duration: String, reaction: ActivityReactionResponse) {
        self.commentId = commentId
        self.duration = duration
        self.reaction = reaction
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case commentId = "comment_id"
        case duration
        case reaction
    }

    public static func == (lhs: AddCommentReactionResponse, rhs: AddCommentReactionResponse) -> Bool {
        lhs.commentId == rhs.commentId &&
            lhs.duration == rhs.duration &&
            lhs.reaction == rhs.reaction
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(commentId)
        hasher.combine(duration)
        hasher.combine(reaction)
    }
}
