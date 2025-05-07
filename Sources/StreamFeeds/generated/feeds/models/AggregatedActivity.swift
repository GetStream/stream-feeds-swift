import Foundation
import StreamCore

public final class AggregatedActivity: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var activities: [Activity]
    public var activityCount: Int
    public var createdAt: Date
    public var group: String
    public var score: Float
    public var updatedAt: Date
    public var userCount: Int

    public init(activities: [Activity], activityCount: Int, createdAt: Date, group: String, score: Float, updatedAt: Date, userCount: Int) {
        self.activities = activities
        self.activityCount = activityCount
        self.createdAt = createdAt
        self.group = group
        self.score = score
        self.updatedAt = updatedAt
        self.userCount = userCount
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case activities
        case activityCount = "activity_count"
        case createdAt = "created_at"
        case group
        case score
        case updatedAt = "updated_at"
        case userCount = "user_count"
    }

    public static func == (lhs: AggregatedActivity, rhs: AggregatedActivity) -> Bool {
        lhs.activities == rhs.activities &&
            lhs.activityCount == rhs.activityCount &&
            lhs.createdAt == rhs.createdAt &&
            lhs.group == rhs.group &&
            lhs.score == rhs.score &&
            lhs.updatedAt == rhs.updatedAt &&
            lhs.userCount == rhs.userCount
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(activities)
        hasher.combine(activityCount)
        hasher.combine(createdAt)
        hasher.combine(group)
        hasher.combine(score)
        hasher.combine(updatedAt)
        hasher.combine(userCount)
    }
}
