import Foundation
import StreamCore

public final class RemoveActivitiesResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var duration: String
    public var removedActivityIds: [String]

    public init(duration: String, removedActivityIds: [String]) {
        self.duration = duration
        self.removedActivityIds = removedActivityIds
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case duration
        case removedActivityIds = "removed_activity_ids"
    }

    public static func == (lhs: RemoveActivitiesResponse, rhs: RemoveActivitiesResponse) -> Bool {
        lhs.duration == rhs.duration &&
            lhs.removedActivityIds == rhs.removedActivityIds
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(duration)
        hasher.combine(removedActivityIds)
    }
}
