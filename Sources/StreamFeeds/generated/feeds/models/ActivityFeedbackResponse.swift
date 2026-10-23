//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Response for activity feedback submission
public final class ActivityFeedbackResponse: Sendable, Codable, JSONEncodable {
    /// The ID of the activity that received feedback
    public let activityId: String
    public let duration: String

    public init(activityId: String, duration: String) {
        self.activityId = activityId
        self.duration = duration
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.activityId = try container.decode(String.self, forKey: .activityId)
        self.duration = try container.decode(String.self, forKey: .duration)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(activityId, forKey: .activityId)
        try container.encode(duration, forKey: .duration)
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
