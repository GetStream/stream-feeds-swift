import Foundation
import StreamCore

public final class UnpinActivityResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var activityId: String
    public var duration: String
    public var fid: String
    public var userId: String

    public init(activityId: String, duration: String, fid: String, userId: String) {
        self.activityId = activityId
        self.duration = duration
        self.fid = fid
        self.userId = userId
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case activityId = "activity_id"
        case duration
        case fid
        case userId = "user_id"
    }

    public static func == (lhs: UnpinActivityResponse, rhs: UnpinActivityResponse) -> Bool {
        lhs.activityId == rhs.activityId &&
            lhs.duration == rhs.duration &&
            lhs.fid == rhs.fid &&
            lhs.userId == rhs.userId
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(activityId)
        hasher.combine(duration)
        hasher.combine(fid)
        hasher.combine(userId)
    }
}
