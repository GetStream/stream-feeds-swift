//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class PushNotificationConfig: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var activityTypes: [String]?
    public var enabled: Bool?

    public init(activityTypes: [String]? = nil, enabled: Bool? = nil) {
        self.activityTypes = activityTypes
        self.enabled = enabled
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case activityTypes = "activity_types"
        case enabled
    }

    public static func == (lhs: PushNotificationConfig, rhs: PushNotificationConfig) -> Bool {
        lhs.activityTypes == rhs.activityTypes &&
            lhs.enabled == rhs.enabled
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(activityTypes)
        hasher.combine(enabled)
    }
}
