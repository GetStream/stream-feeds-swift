//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class ActivityFeedbackResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var activityId: String
    public var duration: String

    public init(activityId: String, duration: String) {
        self.activityId = activityId
        self.duration = duration
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case activityId = "activity_id"
        case duration
    }

    public static func == (lhs: ActivityFeedbackResponse, rhs: ActivityFeedbackResponse) -> Bool {
        lhs.activityId == rhs.activityId &&
            lhs.duration == rhs.duration
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(activityId)
        hasher.combine(duration)
    }
}
