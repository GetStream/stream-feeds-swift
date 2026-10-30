//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class FollowRequest: @unchecked Sendable, Codable, JSONEncodable {
    /// Whether to create a notification activity for this follow
    public var createNotificationActivity: Bool?
    /// Custom data for the follow relationship
    public var custom: [String: RawJSON]?
    /// Push preference for the follow relationship
    public var pushPreference: FollowPushPreference?
    /// Whether to skip push for this follow
    public var skipPush: Bool?
    /// Fully qualified ID of the source feed
    public var source: String
    /// Fully qualified ID of the target feed
    public var target: String

    public init(createNotificationActivity: Bool? = nil, custom: [String: RawJSON]? = nil, pushPreference: FollowPushPreference? = nil, skipPush: Bool? = nil, source: String, target: String) {
        self.createNotificationActivity = createNotificationActivity
        self.custom = custom
        self.pushPreference = pushPreference
        self.skipPush = skipPush
        self.source = source
        self.target = target
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case createNotificationActivity = "create_notification_activity"
        case custom
        case pushPreference = "push_preference"
        case skipPush = "skip_push"
        case source
        case target
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.createNotificationActivity = try container.decodeIfPresent(Bool.self, forKey: .createNotificationActivity)
        self.custom = try container.decodeIfPresent([String: RawJSON].self, forKey: .custom)
        self.pushPreference = try container.decodeIfPresent(FollowPushPreference.self, forKey: .pushPreference)
        self.skipPush = try container.decodeIfPresent(Bool.self, forKey: .skipPush)
        self.source = try container.decode(String.self, forKey: .source)
        self.target = try container.decode(String.self, forKey: .target)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
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
