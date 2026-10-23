//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UpsertActivitiesRequest: Sendable, Codable, JSONEncodable {
    /// List of activities to create or update
    public let activities: [ActivityRequest]

    public init(activities: [ActivityRequest]) {
        self.activities = activities
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.activities = try container.decode([ActivityRequest].self, forKey: .activities)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(activities, forKey: .activities)
    }
}

extension UpsertActivitiesRequest: Hashable {
    public static func == (lhs: UpsertActivitiesRequest, rhs: UpsertActivitiesRequest) -> Bool {
        lhs.activities == rhs.activities
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(activities)
    }
}
