//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UpsertActivitiesRequest: Sendable, Codable, JSONEncodable {
    /// List of activities to create or update
    public let activities: [ActivityRequest]
    /// If true, enriches the activities' current_feed with own_* fields (own_follows, own_followings, own_capabilities, own_membership). Defaults to false for performance.
    public let enrichOwnFields: Bool?

    public init(activities: [ActivityRequest], enrichOwnFields: Bool? = nil) {
        self.activities = activities
        self.enrichOwnFields = enrichOwnFields
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.activities = try container.decode([ActivityRequest].self, forKey: .activities)
        self.enrichOwnFields = try container.decodeIfPresent(Bool.self, forKey: .enrichOwnFields)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(activities, forKey: .activities)
        try container.encodeIfPresent(enrichOwnFields, forKey: .enrichOwnFields)
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
