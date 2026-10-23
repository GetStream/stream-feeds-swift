//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UpsertActivitiesRequest: @unchecked Sendable, Codable, JSONEncodable {
    /// List of activities to create or update
    public var activities: [ActivityRequest]
    /// If true, enriches the activities' current_feed with own_* fields (own_follows, own_followings, own_capabilities, own_membership). Defaults to false for performance.
    public var enrichOwnFields: Bool?

    public init(activities: [ActivityRequest], enrichOwnFields: Bool? = nil) {
        self.activities = activities
        self.enrichOwnFields = enrichOwnFields
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case activities
        case enrichOwnFields = "enrich_own_fields"
    }
}

extension UpsertActivitiesRequest: Hashable {
    public static func == (lhs: UpsertActivitiesRequest, rhs: UpsertActivitiesRequest) -> Bool {
        lhs.activities == rhs.activities &&
            lhs.enrichOwnFields == rhs.enrichOwnFields
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(activities)
        hasher.combine(enrichOwnFields)
    }
}
