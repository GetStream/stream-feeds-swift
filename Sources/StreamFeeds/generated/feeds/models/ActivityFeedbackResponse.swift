//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class ActivityFeedbackResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var activityId: String
    public var duration: String
    public var success: Bool

    public init(activityId: String, duration: String, success: Bool) {
        self.activityId = activityId
        self.duration = duration
        self.success = success
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case activityId = "activity_id"
        case duration
        case success
    }

    public static func == (lhs: ActivityFeedbackResponse, rhs: ActivityFeedbackResponse) -> Bool {
        lhs.activityId == rhs.activityId &&
            lhs.duration == rhs.duration &&
            lhs.success == rhs.success
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(activityId)
        hasher.combine(duration)
        hasher.combine(success)
    }
}
