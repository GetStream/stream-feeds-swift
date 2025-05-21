import Foundation
import StreamCore

public final class CommentReactionAddedEvent: @unchecked Sendable, Event, Codable, JSONEncodable, Hashable {
    public var commentId: String
    public var createdAt: Date
    public var custom: [String: RawJSON]
    public var fid: String
    public var reaction: ActivityReaction
    public var receivedAt: Date?
    public var type: String = "comment.reaction.added"
    public var user: UserResponseCommonFields?

    public init(commentId: String, createdAt: Date, custom: [String: RawJSON], fid: String, reaction: ActivityReaction, receivedAt: Date? = nil, user: UserResponseCommonFields? = nil) {
        self.commentId = commentId
        self.createdAt = createdAt
        self.custom = custom
        self.fid = fid
        self.reaction = reaction
        self.receivedAt = receivedAt
        self.user = user
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case commentId = "comment_id"
        case createdAt = "created_at"
        case custom
        case fid
        case reaction
        case receivedAt = "received_at"
        case type
        case user
    }

    public static func == (lhs: CommentReactionAddedEvent, rhs: CommentReactionAddedEvent) -> Bool {
        lhs.commentId == rhs.commentId &&
            lhs.createdAt == rhs.createdAt &&
            lhs.custom == rhs.custom &&
            lhs.fid == rhs.fid &&
            lhs.reaction == rhs.reaction &&
            lhs.receivedAt == rhs.receivedAt &&
            lhs.type == rhs.type &&
            lhs.user == rhs.user
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(commentId)
        hasher.combine(createdAt)
        hasher.combine(custom)
        hasher.combine(fid)
        hasher.combine(reaction)
        hasher.combine(receivedAt)
        hasher.combine(type)
        hasher.combine(user)
    }
}
