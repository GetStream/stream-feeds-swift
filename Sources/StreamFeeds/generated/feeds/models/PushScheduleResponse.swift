//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// A recurring quiet-hours schedule: while any quiet window is active, push notifications for the user are suppressed. Suppressed notifications are dropped, not delayed.
public final class PushScheduleResponse: @unchecked Sendable, Codable, JSONEncodable {
    /// The quiet windows. Push is suppressed while any rule is active.
    public var quietHours: [QuietHoursRuleResponse]
    /// IANA time zone name the quiet windows are evaluated in, for example Europe/Amsterdam.
    public var timezone: String

    public init(quietHours: [QuietHoursRuleResponse], timezone: String) {
        self.quietHours = quietHours
        self.timezone = timezone
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case quietHours = "quiet_hours"
        case timezone
    }
}

extension PushScheduleResponse: Hashable {
    public static func == (lhs: PushScheduleResponse, rhs: PushScheduleResponse) -> Bool {
        lhs.quietHours == rhs.quietHours &&
            lhs.timezone == rhs.timezone
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(quietHours)
        hasher.combine(timezone)
    }
}
