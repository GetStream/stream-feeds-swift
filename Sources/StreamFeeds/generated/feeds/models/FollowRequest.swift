//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class FollowRequest: Sendable, Encodable, JSONEncodable {
    /// Maximum number of historical activities to copy from the target feed when the follow is first materialized. Not set = unlimited (default). 0 = copy nothing. Range: 0-1000.
    public let activityCopyLimit: Int?
    /// Whether to create a notification activity for this follow
    public let createNotificationActivity: Bool?
    /// Custom data for the follow relationship
    public let custom: [String: RawJSON]?
    /// If true, enriches the follow's source_feed and target_feed with own_* fields (own_follows, own_followings, own_capabilities, own_membership). Defaults to false for performance.
    public let enrichOwnFields: Bool?
    /// Push preference for the follow relationship
    public let pushPreference: FollowPushPreference?
    /// Whether to skip push for this follow
    public let skipPush: Bool?
    /// Fully qualified ID of the source feed
    public let source: String
    /// Fully qualified ID of the target feed
    public let target: String

    public init(activityCopyLimit: Int? = nil, createNotificationActivity: Bool? = nil, custom: [String: RawJSON]? = nil, enrichOwnFields: Bool? = nil, pushPreference: FollowPushPreference? = nil, skipPush: Bool? = nil, source: String, target: String) {
        self.activityCopyLimit = activityCopyLimit
        self.createNotificationActivity = createNotificationActivity
        self.custom = custom
        self.enrichOwnFields = enrichOwnFields
        self.pushPreference = pushPreference
        self.skipPush = skipPush
        self.source = source
        self.target = target
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(activityCopyLimit, forKey: .activityCopyLimit)
        try container.encodeIfPresent(createNotificationActivity, forKey: .createNotificationActivity)
        try container.encodeIfPresent(custom, forKey: .custom)
        try container.encodeIfPresent(enrichOwnFields, forKey: .enrichOwnFields)
        try container.encodeIfPresent(pushPreference, forKey: .pushPreference)
        try container.encodeIfPresent(skipPush, forKey: .skipPush)
        try container.encode(source, forKey: .source)
        try container.encode(target, forKey: .target)
    }
}

extension FollowRequest: Hashable {
    public static func == (lhs: FollowRequest, rhs: FollowRequest) -> Bool {
        lhs.activityCopyLimit == rhs.activityCopyLimit &&
            lhs.createNotificationActivity == rhs.createNotificationActivity &&
            lhs.custom == rhs.custom &&
            lhs.enrichOwnFields == rhs.enrichOwnFields &&
            lhs.pushPreference == rhs.pushPreference &&
            lhs.skipPush == rhs.skipPush &&
            lhs.source == rhs.source &&
            lhs.target == rhs.target
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(activityCopyLimit)
        hasher.combine(createNotificationActivity)
        hasher.combine(custom)
        hasher.combine(enrichOwnFields)
        hasher.combine(pushPreference)
        hasher.combine(skipPush)
        hasher.combine(source)
        hasher.combine(target)
    }
}
