//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Whether a follow sends push notifications.
public final class FollowPushPreference: RawRepresentable, Codable, CustomStringConvertible, Hashable, Sendable {
    public let rawValue: String

    public var description: String { rawValue }

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public static let all = FollowPushPreference(rawValue: "all")
    public static let none = FollowPushPreference(rawValue: "none")
}
