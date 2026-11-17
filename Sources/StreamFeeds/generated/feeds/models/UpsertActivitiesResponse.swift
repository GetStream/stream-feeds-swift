//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UpsertActivitiesResponse: Sendable, Decodable {
    /// List of created or updated activities
    public let activities: [ActivityResponse]

    public init(activities: [ActivityResponse]) {
        self.activities = activities
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.activities = try container.decode([ActivityResponse].self, forKey: .activities)
    }
}

extension UpsertActivitiesResponse: Hashable {
    public static func == (lhs: UpsertActivitiesResponse, rhs: UpsertActivitiesResponse) -> Bool {
        lhs.activities == rhs.activities
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(activities)
    }
}
