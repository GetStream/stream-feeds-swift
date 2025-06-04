import Foundation
import StreamCore

public final class FeedsReactionResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var activityId: String
    public var commentId: String?
    public var createdAt: Date
    public var custom: [String: RawJSON]?
    public var type: String
    public var updatedAt: Date
    public var user: UserResponse

    public init(activityId: String, commentId: String? = nil, createdAt: Date, custom: [String: RawJSON]? = nil, type: String, updatedAt: Date, user: UserResponse) {
        self.activityId = activityId
        self.commentId = commentId
        self.createdAt = createdAt
        self.custom = custom
        self.type = type
        self.updatedAt = updatedAt
        self.user = user
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case activityId = "activity_id"
        case commentId = "comment_id"
        case createdAt = "created_at"
        case custom
        case type
        case updatedAt = "updated_at"
        case user
    }

    public static func == (lhs: FeedsReactionResponse, rhs: FeedsReactionResponse) -> Bool {
        lhs.activityId == rhs.activityId &&
            lhs.commentId == rhs.commentId &&
            lhs.createdAt == rhs.createdAt &&
            lhs.custom == rhs.custom &&
            lhs.type == rhs.type &&
            lhs.updatedAt == rhs.updatedAt &&
            lhs.user == rhs.user
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(activityId)
        hasher.combine(commentId)
        hasher.combine(createdAt)
        hasher.combine(custom)
        hasher.combine(type)
        hasher.combine(updatedAt)
        hasher.combine(user)
    }
}
