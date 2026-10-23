//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UpdateActivityPartialRequest: @unchecked Sendable, Codable, JSONEncodable {
    /// Map of field names to new values. Supported fields: 'text', 'attachments', 'custom', 'visibility', 'visibility_tag', 'restrict_replies' (values: 'everyone', 'people_i_follow', 'nobody'), 'location', 'expires_at', 'filter_tags', 'interest_tags', 'poll_id', 'feeds', 'mentioned_user_ids', 'search_data'. For custom fields, use dot-notation (e.g., 'custom.field_name')
    public var set: [String: RawJSON]?
    /// List of field names to remove. Supported fields: 'custom', 'visibility_tag', 'location', 'expires_at', 'filter_tags', 'interest_tags', 'attachments', 'poll_id', 'mentioned_user_ids', 'search_data'. Use dot-notation for nested custom fields (e.g., 'custom.field_name')
    public var unset: [String]?

    public init(set: [String: RawJSON]? = nil, unset: [String]? = nil) {
        self.set = set
        self.unset = unset
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case set
        case unset
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.set = try container.decodeIfPresent([String: RawJSON].self, forKey: .set)
        self.unset = try container.decodeIfPresent([String].self, forKey: .unset)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(set, forKey: .set)
        try container.encodeIfPresent(unset, forKey: .unset)
    }
}

extension UpdateActivityPartialRequest: Hashable {
    public static func == (lhs: UpdateActivityPartialRequest, rhs: UpdateActivityPartialRequest) -> Bool {
        lhs.set == rhs.set &&
            lhs.unset == rhs.unset
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(set)
        hasher.combine(unset)
    }
}
