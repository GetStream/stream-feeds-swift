import Foundation
import StreamCore

public final class ActionLog: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var createdAt: Date
    public var custom: [String: RawJSON]
    public var id: String
    public var reason: String
    public var reporterType: String
    public var reviewQueueItem: ReviewQueueItem?
    public var reviewQueueItemId: String
    public var targetUser: User?
    public var targetUserId: String
    public var type: String
    public var user: User?

    public init(createdAt: Date, custom: [String: RawJSON], id: String, reason: String, reporterType: String, reviewQueueItem: ReviewQueueItem? = nil, reviewQueueItemId: String, targetUser: User? = nil, targetUserId: String, type: String, user: User? = nil) {
        self.createdAt = createdAt
        self.custom = custom
        self.id = id
        self.reason = reason
        self.reporterType = reporterType
        self.reviewQueueItem = reviewQueueItem
        self.reviewQueueItemId = reviewQueueItemId
        self.targetUser = targetUser
        self.targetUserId = targetUserId
        self.type = type
        self.user = user
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case createdAt = "created_at"
        case custom
        case id
        case reason
        case reporterType = "reporter_type"
        case reviewQueueItem = "review_queue_item"
        case reviewQueueItemId = "review_queue_item_id"
        case targetUser = "target_user"
        case targetUserId = "target_user_id"
        case type
        case user
    }

    public static func == (lhs: ActionLog, rhs: ActionLog) -> Bool {
        lhs.createdAt == rhs.createdAt &&
            lhs.custom == rhs.custom &&
            lhs.id == rhs.id &&
            lhs.reason == rhs.reason &&
            lhs.reporterType == rhs.reporterType &&
            lhs.reviewQueueItem == rhs.reviewQueueItem &&
            lhs.reviewQueueItemId == rhs.reviewQueueItemId &&
            lhs.targetUser == rhs.targetUser &&
            lhs.targetUserId == rhs.targetUserId &&
            lhs.type == rhs.type &&
            lhs.user == rhs.user
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(createdAt)
        hasher.combine(custom)
        hasher.combine(id)
        hasher.combine(reason)
        hasher.combine(reporterType)
        hasher.combine(reviewQueueItem)
        hasher.combine(reviewQueueItemId)
        hasher.combine(targetUser)
        hasher.combine(targetUserId)
        hasher.combine(type)
        hasher.combine(user)
    }
}
