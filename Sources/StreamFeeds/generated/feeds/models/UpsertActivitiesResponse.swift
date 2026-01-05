//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UpsertActivitiesResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var activities: [ActivityResponse]
    public var duration: String

    public init(activities: [ActivityResponse], duration: String) {
        self.activities = activities
        self.duration = duration
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case activities
        case duration
    }

    public static func == (lhs: UpsertActivitiesResponse, rhs: UpsertActivitiesResponse) -> Bool {
        lhs.activities == rhs.activities &&
            lhs.duration == rhs.duration
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(activities)
        hasher.combine(duration)
    }
}
