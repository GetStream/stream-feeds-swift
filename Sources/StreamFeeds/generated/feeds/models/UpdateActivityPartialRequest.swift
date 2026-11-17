//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UpdateActivityPartialRequest: Sendable, Encodable, JSONEncodable {
    /// If true, enriches the activity's current_feed with own_* fields (own_follows, own_followings, own_capabilities, own_membership). Defaults to false for performance.
    public let enrichOwnFields: Bool?
    /// If true, creates notification activities for newly mentioned users and deletes notifications for users no longer mentioned
    public let handleMentionNotifications: Bool?
    /// If true, runs activity processors on the updated activity. Processors will only run if the activity text and/or attachments are changed. Defaults to false.
    public let runActivityProcessors: Bool?
    /// Map of field names to new values. Supported fields: 'text', 'attachments', 'custom', 'visibility', 'visibility_tag', 'restrict_replies' (values: 'everyone', 'people_i_follow', 'nobody'), 'location', 'expires_at', 'filter_tags', 'interest_tags', 'poll_id', 'feeds', 'mentioned_user_ids', 'search_data'. For custom fields, use dot-notation (e.g., 'custom.field_name')
    public let set: [String: RawJSON]?
    /// List of field names to remove. Supported fields: 'custom', 'visibility_tag', 'location', 'expires_at', 'filter_tags', 'interest_tags', 'attachments', 'poll_id', 'mentioned_user_ids', 'search_data'. Use dot-notation for nested custom fields (e.g., 'custom.field_name')
    public let unset: [String]?

    public init(enrichOwnFields: Bool? = nil, handleMentionNotifications: Bool? = nil, runActivityProcessors: Bool? = nil, set: [String: RawJSON]? = nil, unset: [String]? = nil) {
        self.enrichOwnFields = enrichOwnFields
        self.handleMentionNotifications = handleMentionNotifications
        self.runActivityProcessors = runActivityProcessors
        self.set = set
        self.unset = unset
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(enrichOwnFields, forKey: .enrichOwnFields)
        try container.encodeIfPresent(handleMentionNotifications, forKey: .handleMentionNotifications)
        try container.encodeIfPresent(runActivityProcessors, forKey: .runActivityProcessors)
        try container.encodeIfPresent(set, forKey: .set)
        try container.encodeIfPresent(unset, forKey: .unset)
    }
}

extension UpdateActivityPartialRequest: Hashable {
    public static func == (lhs: UpdateActivityPartialRequest, rhs: UpdateActivityPartialRequest) -> Bool {
        lhs.enrichOwnFields == rhs.enrichOwnFields &&
            lhs.handleMentionNotifications == rhs.handleMentionNotifications &&
            lhs.runActivityProcessors == rhs.runActivityProcessors &&
            lhs.set == rhs.set &&
            lhs.unset == rhs.unset
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(enrichOwnFields)
        hasher.combine(handleMentionNotifications)
        hasher.combine(runActivityProcessors)
        hasher.combine(set)
        hasher.combine(unset)
    }
}
