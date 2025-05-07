import Foundation
import StreamCore

public final class ActivityReaction: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var activityId: String
    public var createdAt: Date
    public var custom: [String: RawJSON]?
    public var type: String
    public var updatedAt: Date
    public var user: UserResponse

    public init(activityId: String, createdAt: Date, custom: [String: RawJSON]? = nil, type: String, updatedAt: Date, user: UserResponse) {
        self.activityId = activityId
        self.createdAt = createdAt
        self.custom = custom
        self.type = type
        self.updatedAt = updatedAt
        self.user = user
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case activityId = "activity_id"
        case createdAt = "created_at"
        case custom
        case type
        case updatedAt = "updated_at"
        case user
    }

    public static func == (lhs: ActivityReaction, rhs: ActivityReaction) -> Bool {
        lhs.activityId == rhs.activityId &&
            lhs.createdAt == rhs.createdAt &&
            lhs.custom == rhs.custom &&
            lhs.type == rhs.type &&
            lhs.updatedAt == rhs.updatedAt &&
            lhs.user == rhs.user
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(activityId)
        hasher.combine(createdAt)
        hasher.combine(custom)
        hasher.combine(type)
        hasher.combine(updatedAt)
        hasher.combine(user)
    }
}
