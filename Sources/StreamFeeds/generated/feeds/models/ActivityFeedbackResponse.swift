//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Response for activity feedback submission
public final class ActivityFeedbackResponse: @unchecked Sendable, Codable, JSONEncodable {
    /// The ID of the activity that received feedback
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
}

extension ActivityFeedbackResponse: Hashable {
    public static func == (lhs: ActivityFeedbackResponse, rhs: ActivityFeedbackResponse) -> Bool {
        lhs.activityId == rhs.activityId &&
            lhs.duration == rhs.duration
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(activityId)
        hasher.combine(duration)
    }
}
