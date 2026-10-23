//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class AddCommentReactionRequest: @unchecked Sendable, Codable, JSONEncodable {
    /// Whether to copy custom data to the notification activity (only applies when create_notification_activity is true) Deprecated: use notification_context.trigger.custom and notification_context.target.custom instead
    @available(
        *,
        deprecated,
        message: "use notification_context.trigger.custom and notification_context.target.custom instead"
    )
    public var copyCustomToNotification: Bool? { get { _copyCustomToNotification } set { _copyCustomToNotification = newValue } }
    private var _copyCustomToNotification: Bool?
    /// Whether to create a notification activity for this reaction
    public var createNotificationActivity: Bool?
    /// Optional custom data to add to the reaction
    public var custom: [String: RawJSON]?
    /// Whether to enforce unique reactions per user (remove other reaction types from the user when adding this one)
    public var enforceUnique: Bool?
    public var skipPush: Bool?
    /// Optional list of feeds to create a reference (share) activity of the commented-on activity in. The reference activity's type mirrors the reaction type.
    public var targetFeeds: [String]?
    /// The type of reaction, eg upvote, like, ...
    public var type: String

    public init(
        copyCustomToNotification: Bool? = nil,
        createNotificationActivity: Bool? = nil,
        custom: [String: RawJSON]? = nil,
        enforceUnique: Bool? = nil,
        skipPush: Bool? = nil,
        targetFeeds: [String]? = nil,
        type: String
    ) {
        self._copyCustomToNotification = copyCustomToNotification
        self.createNotificationActivity = createNotificationActivity
        self.custom = custom
        self.enforceUnique = enforceUnique
        self.skipPush = skipPush
        self.targetFeeds = targetFeeds
        self.type = type
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case copyCustomToNotification = "copy_custom_to_notification"
        case createNotificationActivity = "create_notification_activity"
        case custom
        case enforceUnique = "enforce_unique"
        case skipPush = "skip_push"
        case targetFeeds = "target_feeds"
        case type
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self._copyCustomToNotification = try container.decodeIfPresent(
            Bool.self,
            forKey: .copyCustomToNotification
        )
        self.createNotificationActivity = try container.decodeIfPresent(
            Bool.self,
            forKey: .createNotificationActivity
        )
        self.custom = try container.decodeIfPresent([String: RawJSON].self, forKey: .custom)
        self.enforceUnique = try container.decodeIfPresent(Bool.self, forKey: .enforceUnique)
        self.skipPush = try container.decodeIfPresent(Bool.self, forKey: .skipPush)
        self.targetFeeds = try container.decodeIfPresent([String].self, forKey: .targetFeeds)
        self.type = try container.decode(String.self, forKey: .type)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(_copyCustomToNotification, forKey: .copyCustomToNotification)
        try container.encodeIfPresent(
            createNotificationActivity,
            forKey: .createNotificationActivity
        )
        try container.encodeIfPresent(custom, forKey: .custom)
        try container.encodeIfPresent(enforceUnique, forKey: .enforceUnique)
        try container.encodeIfPresent(skipPush, forKey: .skipPush)
        try container.encodeIfPresent(targetFeeds, forKey: .targetFeeds)
        try container.encode(type, forKey: .type)
    }
}

extension AddCommentReactionRequest: Hashable {
    public static func == (lhs: AddCommentReactionRequest, rhs: AddCommentReactionRequest) -> Bool {
        lhs._copyCustomToNotification == rhs._copyCustomToNotification &&
            lhs.createNotificationActivity == rhs.createNotificationActivity &&
            lhs.custom == rhs.custom &&
            lhs.enforceUnique == rhs.enforceUnique &&
            lhs.skipPush == rhs.skipPush &&
            lhs.targetFeeds == rhs.targetFeeds &&
            lhs.type == rhs.type
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(_copyCustomToNotification)
        hasher.combine(createNotificationActivity)
        hasher.combine(custom)
        hasher.combine(enforceUnique)
        hasher.combine(skipPush)
        hasher.combine(targetFeeds)
        hasher.combine(type)
    }
}
