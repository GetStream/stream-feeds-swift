//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class NotificationContext: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var target: NotificationTarget?
    public var trigger: NotificationTrigger?

    public init(target: NotificationTarget? = nil, trigger: NotificationTrigger? = nil) {
        self.target = target
        self.trigger = trigger
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case target
        case trigger
    }

    public static func == (lhs: NotificationContext, rhs: NotificationContext) -> Bool {
        lhs.target == rhs.target &&
            lhs.trigger == rhs.trigger
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(target)
        hasher.combine(trigger)
    }
}
