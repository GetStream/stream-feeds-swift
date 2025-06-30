import Foundation
import StreamCore

public final class ActionLogResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var createdAt: Date
    public var custom: [String: RawJSON]
    public var id: String
    public var reason: String
    public var reviewQueueItem: ReviewQueueItemResponse?
    public var targetUser: UserResponse?
    public var targetUserId: String
    public var type: String
    public var user: UserResponse?
    public var userId: String

    public init(createdAt: Date, custom: [String: RawJSON], id: String, reason: String, reviewQueueItem: ReviewQueueItemResponse? = nil, targetUser: UserResponse? = nil, targetUserId: String, type: String, user: UserResponse? = nil, userId: String) {
        self.createdAt = createdAt
        self.custom = custom
        self.id = id
        self.reason = reason
        self.reviewQueueItem = reviewQueueItem
        self.targetUser = targetUser
        self.targetUserId = targetUserId
        self.type = type
        self.user = user
        self.userId = userId
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case createdAt = "created_at"
        case custom
        case id
        case reason
        case reviewQueueItem = "review_queue_item"
        case targetUser = "target_user"
        case targetUserId = "target_user_id"
        case type
        case user
        case userId = "user_id"
    }

    public static func == (lhs: ActionLogResponse, rhs: ActionLogResponse) -> Bool {
        lhs.createdAt == rhs.createdAt &&
            lhs.custom == rhs.custom &&
            lhs.id == rhs.id &&
            lhs.reason == rhs.reason &&
            lhs.reviewQueueItem == rhs.reviewQueueItem &&
            lhs.targetUser == rhs.targetUser &&
            lhs.targetUserId == rhs.targetUserId &&
            lhs.type == rhs.type &&
            lhs.user == rhs.user &&
            lhs.userId == rhs.userId
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(createdAt)
        hasher.combine(custom)
        hasher.combine(id)
        hasher.combine(reason)
        hasher.combine(reviewQueueItem)
        hasher.combine(targetUser)
        hasher.combine(targetUserId)
        hasher.combine(type)
        hasher.combine(user)
        hasher.combine(userId)
    }
}
