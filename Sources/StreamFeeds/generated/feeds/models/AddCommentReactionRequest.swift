//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class AddCommentReactionRequest: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var createNotificationActivity: Bool?
    public var custom: [String: RawJSON]?
    public var skipPush: Bool?
    public var type: String

    public init(createNotificationActivity: Bool? = nil, custom: [String: RawJSON]? = nil, skipPush: Bool? = nil, type: String) {
        self.createNotificationActivity = createNotificationActivity
        self.custom = custom
        self.skipPush = skipPush
        self.type = type
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case createNotificationActivity = "create_notification_activity"
        case custom
        case skipPush = "skip_push"
        case type
    }

    public static func == (lhs: AddCommentReactionRequest, rhs: AddCommentReactionRequest) -> Bool {
        lhs.createNotificationActivity == rhs.createNotificationActivity &&
            lhs.custom == rhs.custom &&
            lhs.skipPush == rhs.skipPush &&
            lhs.type == rhs.type
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(createNotificationActivity)
        hasher.combine(custom)
        hasher.combine(skipPush)
        hasher.combine(type)
    }
}
