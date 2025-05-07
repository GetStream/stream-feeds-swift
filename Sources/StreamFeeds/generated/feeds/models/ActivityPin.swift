import Foundation
import StreamCore

public final class ActivityPin: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var activityId: String
    public var createdAt: Date
    public var feed: String
    public var updatedAt: Date
    public var user: UserResponse

    public init(activityId: String, createdAt: Date, feed: String, updatedAt: Date, user: UserResponse) {
        self.activityId = activityId
        self.createdAt = createdAt
        self.feed = feed
        self.updatedAt = updatedAt
        self.user = user
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case activityId = "activity_id"
        case createdAt = "created_at"
        case feed
        case updatedAt = "updated_at"
        case user
    }

    public static func == (lhs: ActivityPin, rhs: ActivityPin) -> Bool {
        lhs.activityId == rhs.activityId &&
            lhs.createdAt == rhs.createdAt &&
            lhs.feed == rhs.feed &&
            lhs.updatedAt == rhs.updatedAt &&
            lhs.user == rhs.user
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(activityId)
        hasher.combine(createdAt)
        hasher.combine(feed)
        hasher.combine(updatedAt)
        hasher.combine(user)
    }
}
