//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class FollowRequest: Sendable, Encodable, JSONEncodable {
    /// Whether to create a notification activity for this follow
    public let createNotificationActivity: Bool?
    /// Custom data for the follow relationship
    public let custom: [String: RawJSON]?
    /// Push preference for the follow relationship
    public let pushPreference: FollowPushPreference?
    /// Whether to skip push for this follow
    public let skipPush: Bool?
    /// Fully qualified ID of the source feed
    public let source: String
    /// Fully qualified ID of the target feed
    public let target: String

    public init(createNotificationActivity: Bool? = nil, custom: [String: RawJSON]? = nil, pushPreference: FollowPushPreference? = nil, skipPush: Bool? = nil, source: String, target: String) {
        self.createNotificationActivity = createNotificationActivity
        self.custom = custom
        self.pushPreference = pushPreference
        self.skipPush = skipPush
        self.source = source
        self.target = target
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(createNotificationActivity, forKey: .createNotificationActivity)
        try container.encodeIfPresent(custom, forKey: .custom)
        try container.encodeIfPresent(pushPreference, forKey: .pushPreference)
        try container.encodeIfPresent(skipPush, forKey: .skipPush)
        try container.encode(source, forKey: .source)
        try container.encode(target, forKey: .target)
    }
}

extension FollowRequest: Hashable {
    public static func == (lhs: FollowRequest, rhs: FollowRequest) -> Bool {
        lhs.createNotificationActivity == rhs.createNotificationActivity &&
            lhs.custom == rhs.custom &&
            lhs.pushPreference == rhs.pushPreference &&
            lhs.skipPush == rhs.skipPush &&
            lhs.source == rhs.source &&
            lhs.target == rhs.target
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(createNotificationActivity)
        hasher.combine(custom)
        hasher.combine(pushPreference)
        hasher.combine(skipPush)
        hasher.combine(source)
        hasher.combine(target)
    }
}
