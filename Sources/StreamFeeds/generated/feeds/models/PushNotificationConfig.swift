//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class PushNotificationConfig: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var enablePush: Bool?
    public var pushTypes: [String]?

    public init(enablePush: Bool? = nil, pushTypes: [String]? = nil) {
        self.enablePush = enablePush
        self.pushTypes = pushTypes
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case enablePush = "enable_push"
        case pushTypes = "push_types"
    }

    public static func == (lhs: PushNotificationConfig, rhs: PushNotificationConfig) -> Bool {
        lhs.enablePush == rhs.enablePush &&
            lhs.pushTypes == rhs.pushTypes
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(enablePush)
        hasher.combine(pushTypes)
    }
}
