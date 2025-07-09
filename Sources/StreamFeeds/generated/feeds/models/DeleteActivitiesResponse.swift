//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class DeleteActivitiesResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var deletedActivityIds: [String]
    public var duration: String

    public init(deletedActivityIds: [String], duration: String) {
        self.deletedActivityIds = deletedActivityIds
        self.duration = duration
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case deletedActivityIds = "deleted_activity_ids"
        case duration
    }

    public static func == (lhs: DeleteActivitiesResponse, rhs: DeleteActivitiesResponse) -> Bool {
        lhs.deletedActivityIds == rhs.deletedActivityIds &&
            lhs.duration == rhs.duration
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(deletedActivityIds)
        hasher.combine(duration)
    }
}
