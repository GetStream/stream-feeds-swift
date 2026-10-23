//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class FollowRequest: @unchecked Sendable, Codable, JSONEncodable {
    public enum FollowRequestPushPreference: String, Sendable, Codable, CaseIterable {
        case all
        case none
        case unknown = "_unknown"

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let decodedValue = try? container.decode(String.self),
               let value = Self(rawValue: decodedValue) {
                self = value
            } else {
                self = .unknown
            }
        }
    }

    /// Maximum number of historical activities to copy from the target feed when the follow is first materialized. Not set = unlimited (default). 0 = copy nothing. Range: 0-1000.
    public var activityCopyLimit: Int?
    /// Whether to copy custom data to the notification activity (only applies when create_notification_activity is true) Deprecated: use notification_context.trigger.custom and notification_context.target.custom instead
    @available(*, deprecated, message: "use notification_context.trigger.custom and notification_context.target.custom instead")
    public var copyCustomToNotification: Bool? { get { _copyCustomToNotification } set { _copyCustomToNotification = newValue } }
    private var _copyCustomToNotification: Bool?
    /// Whether to create a notification activity for this follow
    public var createNotificationActivity: Bool?
    /// Custom data for the follow relationship
    public var custom: [String: RawJSON]?
    /// If true, enriches the follow's source_feed and target_feed with own_* fields (own_follows, own_followings, own_capabilities, own_membership). Defaults to false for performance.
    public var enrichOwnFields: Bool?
    /// Push preference for the follow relationship
    public var pushPreference: FollowRequestPushPreference?
    /// Whether to skip push for this follow
    public var skipPush: Bool?
    /// Fully qualified ID of the source feed
    public var source: String
    /// Fully qualified ID of the target feed
    public var target: String

    public init(activityCopyLimit: Int? = nil, copyCustomToNotification: Bool? = nil, createNotificationActivity: Bool? = nil, custom: [String: RawJSON]? = nil, enrichOwnFields: Bool? = nil, pushPreference: FollowRequestPushPreference? = nil, skipPush: Bool? = nil, source: String, target: String) {
        self.activityCopyLimit = activityCopyLimit
        self._copyCustomToNotification = copyCustomToNotification
        self.createNotificationActivity = createNotificationActivity
        self.custom = custom
        self.enrichOwnFields = enrichOwnFields
        self.pushPreference = pushPreference
        self.skipPush = skipPush
        self.source = source
        self.target = target
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case activityCopyLimit = "activity_copy_limit"
        case copyCustomToNotification = "copy_custom_to_notification"
        case createNotificationActivity = "create_notification_activity"
        case custom
        case enrichOwnFields = "enrich_own_fields"
        case pushPreference = "push_preference"
        case skipPush = "skip_push"
        case source
        case target
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.activityCopyLimit = try container.decodeIfPresent(Int.self, forKey: .activityCopyLimit)
        self._copyCustomToNotification = try container.decodeIfPresent(Bool.self, forKey: .copyCustomToNotification)
        self.createNotificationActivity = try container.decodeIfPresent(Bool.self, forKey: .createNotificationActivity)
        self.custom = try container.decodeIfPresent([String: RawJSON].self, forKey: .custom)
        self.enrichOwnFields = try container.decodeIfPresent(Bool.self, forKey: .enrichOwnFields)
        self.pushPreference = try container.decodeIfPresent(FollowRequestPushPreference.self, forKey: .pushPreference)
        self.skipPush = try container.decodeIfPresent(Bool.self, forKey: .skipPush)
        self.source = try container.decode(String.self, forKey: .source)
        self.target = try container.decode(String.self, forKey: .target)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(activityCopyLimit, forKey: .activityCopyLimit)
        try container.encodeIfPresent(_copyCustomToNotification, forKey: .copyCustomToNotification)
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
            lhs._copyCustomToNotification == rhs._copyCustomToNotification &&
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
        hasher.combine(_copyCustomToNotification)
        hasher.combine(createNotificationActivity)
        hasher.combine(custom)
        hasher.combine(enrichOwnFields)
        hasher.combine(pushPreference)
        hasher.combine(skipPush)
        hasher.combine(source)
        hasher.combine(target)
    }
}
