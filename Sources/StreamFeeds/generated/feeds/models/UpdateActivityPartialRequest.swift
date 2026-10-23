//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UpdateActivityPartialRequest: @unchecked Sendable, Codable, JSONEncodable {
    /// Whether to copy custom data to the notification activity (only applies when handle_mention_notifications creates notifications) Deprecated: use notification_context.trigger.custom and notification_context.target.custom instead
    @available(*, deprecated, message: "use notification_context.trigger.custom and notification_context.target.custom instead")
    public var copyCustomToNotification: Bool? { get { _copyCustomToNotification } set { _copyCustomToNotification = newValue } }
    private var _copyCustomToNotification: Bool?
    /// If true, enriches the activity's current_feed with own_* fields (own_follows, own_followings, own_capabilities, own_membership). Defaults to false for performance.
    public var enrichOwnFields: Bool?
    /// If true, creates notification activities for newly mentioned users and deletes notifications for users no longer mentioned
    public var handleMentionNotifications: Bool?
    /// If true, runs activity processors on the updated activity. Processors will only run if the activity text and/or attachments are changed. Defaults to false.
    public var runActivityProcessors: Bool?
    /// Map of field names to new values. Supported fields: 'text', 'attachments', 'custom', 'visibility', 'visibility_tag', 'restrict_replies' (values: 'everyone', 'people_i_follow', 'nobody'), 'location', 'expires_at', 'filter_tags', 'interest_tags', 'poll_id', 'feeds', 'mentioned_user_ids', 'search_data'. For custom fields, use dot-notation (e.g., 'custom.field_name')
    public var set: [String: RawJSON]?
    /// List of field names to remove. Supported fields: 'custom', 'visibility_tag', 'location', 'expires_at', 'filter_tags', 'interest_tags', 'attachments', 'poll_id', 'mentioned_user_ids', 'search_data'. Use dot-notation for nested custom fields (e.g., 'custom.field_name')
    public var unset: [String]?

    public init(copyCustomToNotification: Bool? = nil, enrichOwnFields: Bool? = nil, handleMentionNotifications: Bool? = nil, runActivityProcessors: Bool? = nil, set: [String: RawJSON]? = nil, unset: [String]? = nil) {
        self._copyCustomToNotification = copyCustomToNotification
        self.enrichOwnFields = enrichOwnFields
        self.handleMentionNotifications = handleMentionNotifications
        self.runActivityProcessors = runActivityProcessors
        self.set = set
        self.unset = unset
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case copyCustomToNotification = "copy_custom_to_notification"
        case enrichOwnFields = "enrich_own_fields"
        case handleMentionNotifications = "handle_mention_notifications"
        case runActivityProcessors = "run_activity_processors"
        case set
        case unset
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self._copyCustomToNotification = try container.decodeIfPresent(Bool.self, forKey: .copyCustomToNotification)
        self.enrichOwnFields = try container.decodeIfPresent(Bool.self, forKey: .enrichOwnFields)
        self.handleMentionNotifications = try container.decodeIfPresent(Bool.self, forKey: .handleMentionNotifications)
        self.runActivityProcessors = try container.decodeIfPresent(Bool.self, forKey: .runActivityProcessors)
        self.set = try container.decodeIfPresent([String: RawJSON].self, forKey: .set)
        self.unset = try container.decodeIfPresent([String].self, forKey: .unset)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(_copyCustomToNotification, forKey: .copyCustomToNotification)
        try container.encodeIfPresent(enrichOwnFields, forKey: .enrichOwnFields)
        try container.encodeIfPresent(handleMentionNotifications, forKey: .handleMentionNotifications)
        try container.encodeIfPresent(runActivityProcessors, forKey: .runActivityProcessors)
        try container.encodeIfPresent(set, forKey: .set)
        try container.encodeIfPresent(unset, forKey: .unset)
    }
}

extension UpdateActivityPartialRequest: Hashable {
    public static func == (lhs: UpdateActivityPartialRequest, rhs: UpdateActivityPartialRequest) -> Bool {
        lhs._copyCustomToNotification == rhs._copyCustomToNotification &&
            lhs.enrichOwnFields == rhs.enrichOwnFields &&
            lhs.handleMentionNotifications == rhs.handleMentionNotifications &&
            lhs.runActivityProcessors == rhs.runActivityProcessors &&
            lhs.set == rhs.set &&
            lhs.unset == rhs.unset
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(_copyCustomToNotification)
        hasher.combine(enrichOwnFields)
        hasher.combine(handleMentionNotifications)
        hasher.combine(runActivityProcessors)
        hasher.combine(set)
        hasher.combine(unset)
    }
}
