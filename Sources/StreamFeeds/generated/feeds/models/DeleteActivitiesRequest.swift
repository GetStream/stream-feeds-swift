//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class DeleteActivitiesRequest: Sendable, Codable, JSONEncodable {
    /// Whether to also delete any notification activities created from mentions in these activities
    public let deleteNotificationActivity: Bool?
    /// Whether to permanently delete the activities
    public let hardDelete: Bool?
    /// List of activity IDs to delete
    public let ids: [String]

    public init(deleteNotificationActivity: Bool? = nil, hardDelete: Bool? = nil, ids: [String]) {
        self.deleteNotificationActivity = deleteNotificationActivity
        self.hardDelete = hardDelete
        self.ids = ids
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.deleteNotificationActivity = try container.decodeIfPresent(Bool.self, forKey: .deleteNotificationActivity)
        self.hardDelete = try container.decodeIfPresent(Bool.self, forKey: .hardDelete)
        self.ids = try container.decode([String].self, forKey: .ids)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(deleteNotificationActivity, forKey: .deleteNotificationActivity)
        try container.encodeIfPresent(hardDelete, forKey: .hardDelete)
        try container.encode(ids, forKey: .ids)
    }
}

extension DeleteActivitiesRequest: Hashable {
    public static func == (lhs: DeleteActivitiesRequest, rhs: DeleteActivitiesRequest) -> Bool {
        lhs.deleteNotificationActivity == rhs.deleteNotificationActivity &&
            lhs.hardDelete == rhs.hardDelete &&
            lhs.ids == rhs.ids
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(deleteNotificationActivity)
        hasher.combine(hardDelete)
        hasher.combine(ids)
    }
}
