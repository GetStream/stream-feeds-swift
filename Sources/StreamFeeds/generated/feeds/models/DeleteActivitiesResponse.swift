//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class DeleteActivitiesResponse: @unchecked Sendable, Codable, JSONEncodable {
    /// List of activity IDs that were successfully deleted
    public var deletedIds: [String]
    public var duration: String

    public init(deletedIds: [String], duration: String) {
        self.deletedIds = deletedIds
        self.duration = duration
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case deletedIds = "deleted_ids"
        case duration
    }
}

extension DeleteActivitiesResponse: Hashable {
    public static func == (lhs: DeleteActivitiesResponse, rhs: DeleteActivitiesResponse) -> Bool {
        lhs.deletedIds == rhs.deletedIds &&
            lhs.duration == rhs.duration
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(deletedIds)
        hasher.combine(duration)
    }
}
