import Foundation
import StreamCore

public final class CreateActivitiesBatchResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var activities: [Activity]
    public var duration: String

    public init(activities: [Activity], duration: String) {
        self.activities = activities
        self.duration = duration
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case activities
        case duration
    }

    public static func == (lhs: CreateActivitiesBatchResponse, rhs: CreateActivitiesBatchResponse) -> Bool {
        lhs.activities == rhs.activities &&
            lhs.duration == rhs.duration
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(activities)
        hasher.combine(duration)
    }
}
