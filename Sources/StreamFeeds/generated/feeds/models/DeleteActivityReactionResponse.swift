import Foundation
import StreamCore

public final class DeleteActivityReactionResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var activityId: String
    public var duration: String
    public var type: String
    public var userId: String

    public init(activityId: String, duration: String, type: String, userId: String) {
        self.activityId = activityId
        self.duration = duration
        self.type = type
        self.userId = userId
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case activityId = "activity_id"
        case duration
        case type
        case userId = "user_id"
    }

    public static func == (lhs: DeleteActivityReactionResponse, rhs: DeleteActivityReactionResponse) -> Bool {
        lhs.activityId == rhs.activityId &&
            lhs.duration == rhs.duration &&
            lhs.type == rhs.type &&
            lhs.userId == rhs.userId
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(activityId)
        hasher.combine(duration)
        hasher.combine(type)
        hasher.combine(userId)
    }
}
