//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UpsertActivitiesRequest: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var activities: [ActivityRequest]

    public init(activities: [ActivityRequest]) {
        self.activities = activities
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case activities
    }

    public static func == (lhs: UpsertActivitiesRequest, rhs: UpsertActivitiesRequest) -> Bool {
        lhs.activities == rhs.activities
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(activities)
    }
}
