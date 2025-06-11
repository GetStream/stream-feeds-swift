import Foundation
import StreamCore

public final class UnpinActivityResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var activity: ActivityResponse
    public var duration: String
    public var fid: String
    public var userId: String

    public init(activity: ActivityResponse, duration: String, fid: String, userId: String) {
        self.activity = activity
        self.duration = duration
        self.fid = fid
        self.userId = userId
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case activity
        case duration
        case fid
        case userId = "user_id"
    }

    public static func == (lhs: UnpinActivityResponse, rhs: UnpinActivityResponse) -> Bool {
        lhs.activity == rhs.activity &&
            lhs.duration == rhs.duration &&
            lhs.fid == rhs.fid &&
            lhs.userId == rhs.userId
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(activity)
        hasher.combine(duration)
        hasher.combine(fid)
        hasher.combine(userId)
    }
}
