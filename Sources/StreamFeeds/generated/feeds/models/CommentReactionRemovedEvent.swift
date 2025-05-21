import Foundation
import StreamCore

public final class CommentReactionRemovedEvent: @unchecked Sendable, Event, Codable, JSONEncodable, Hashable {
    public var commentId: String
    public var createdAt: Date
    public var custom: [String: RawJSON]
    public var fid: String
    public var receivedAt: Date?
    public var type: String = "comment.reaction.removed"
    public var userId: String

    public init(commentId: String, createdAt: Date, custom: [String: RawJSON], fid: String, receivedAt: Date? = nil, userId: String) {
        self.commentId = commentId
        self.createdAt = createdAt
        self.custom = custom
        self.fid = fid
        self.receivedAt = receivedAt
        self.userId = userId
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case commentId = "comment_id"
        case createdAt = "created_at"
        case custom
        case fid
        case receivedAt = "received_at"
        case type
        case userId = "user_id"
    }

    public static func == (lhs: CommentReactionRemovedEvent, rhs: CommentReactionRemovedEvent) -> Bool {
        lhs.commentId == rhs.commentId &&
            lhs.createdAt == rhs.createdAt &&
            lhs.custom == rhs.custom &&
            lhs.fid == rhs.fid &&
            lhs.receivedAt == rhs.receivedAt &&
            lhs.type == rhs.type &&
            lhs.userId == rhs.userId
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(commentId)
        hasher.combine(createdAt)
        hasher.combine(custom)
        hasher.combine(fid)
        hasher.combine(receivedAt)
        hasher.combine(type)
        hasher.combine(userId)
    }
}
