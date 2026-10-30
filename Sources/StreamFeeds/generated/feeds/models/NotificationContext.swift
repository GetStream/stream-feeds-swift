//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class NotificationContext: Sendable, Decodable {
    public let target: NotificationTarget?
    public let trigger: NotificationTrigger?

    public init(target: NotificationTarget? = nil, trigger: NotificationTrigger? = nil) {
        self.target = target
        self.trigger = trigger
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.target = try container.decodeIfPresent(NotificationTarget.self, forKey: .target)
        self.trigger = try container.decodeIfPresent(NotificationTrigger.self, forKey: .trigger)
    }
}

extension NotificationContext: Hashable {
    public static func == (lhs: NotificationContext, rhs: NotificationContext) -> Bool {
        lhs.target == rhs.target &&
            lhs.trigger == rhs.trigger
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(target)
        hasher.combine(trigger)
    }
}
