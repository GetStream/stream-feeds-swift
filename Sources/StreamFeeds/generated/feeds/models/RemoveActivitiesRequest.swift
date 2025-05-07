import Foundation
import StreamCore

public final class RemoveActivitiesRequest: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var activityIds: [String]
    public var hardDelete: Bool?

    public init(activityIds: [String], hardDelete: Bool? = nil) {
        self.activityIds = activityIds
        self.hardDelete = hardDelete
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case activityIds = "activity_ids"
        case hardDelete = "hard_delete"
    }

    public static func == (lhs: RemoveActivitiesRequest, rhs: RemoveActivitiesRequest) -> Bool {
        lhs.activityIds == rhs.activityIds &&
            lhs.hardDelete == rhs.hardDelete
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(activityIds)
        hasher.combine(hardDelete)
    }
}
