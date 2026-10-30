//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// What a moderation rule does when it matches.
public final class ModerationAction: RawRepresentable, Codable, Hashable, Sendable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public static let bounce = ModerationAction(rawValue: "bounce")
    public static let bounceFlag = ModerationAction(rawValue: "bounce_flag")
    public static let bounceRemove = ModerationAction(rawValue: "bounce_remove")
    public static let flag = ModerationAction(rawValue: "flag")
    public static let remove = ModerationAction(rawValue: "remove")
    public static let shadow = ModerationAction(rawValue: "shadow")
}
