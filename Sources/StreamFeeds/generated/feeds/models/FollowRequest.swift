//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class FollowRequestPushPreference: RawRepresentable, Codable, Hashable, Sendable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public static let all = FollowRequestPushPreference(rawValue: "all")
    public static let none = FollowRequestPushPreference(rawValue: "none")
}

public final class FollowRequest: Sendable, Codable, JSONEncodable {
    /// Whether to create a notification activity for this follow
    public let createNotificationActivity: Bool?
    /// Custom data for the follow relationship
    public let custom: [String: RawJSON]?
    /// Push preference for the follow relationship
    public let pushPreference: FollowRequestPushPreference?
    /// Whether to skip push for this follow
    public let skipPush: Bool?
    /// Fully qualified ID of the source feed
    public let source: String
    /// Fully qualified ID of the target feed
    public let target: String

    public init(createNotificationActivity: Bool? = nil, custom: [String: RawJSON]? = nil, pushPreference: FollowRequestPushPreference? = nil, skipPush: Bool? = nil, source: String, target: String) {
        self.createNotificationActivity = createNotificationActivity
        self.custom = custom
        self.pushPreference = pushPreference
        self.skipPush = skipPush
        self.source = source
        self.target = target
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.createNotificationActivity = try container.decodeIfPresent(Bool.self, forKey: .createNotificationActivity)
        self.custom = try container.decodeIfPresent([String: RawJSON].self, forKey: .custom)
        self.pushPreference = try container.decodeIfPresent(FollowRequestPushPreference.self, forKey: .pushPreference)
        self.skipPush = try container.decodeIfPresent(Bool.self, forKey: .skipPush)
        self.source = try container.decode(String.self, forKey: .source)
        self.target = try container.decode(String.self, forKey: .target)
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
