//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Request to get own_follows, own_followings, own_capabilities, and/or own_membership for multiple feeds. If fields is not specified, all fields are returned.
public final class OwnBatchRequest: @unchecked Sendable, Codable, JSONEncodable {
    /// List of feed IDs to get own fields for
    public var feeds: [String]
    /// Optional list of specific fields to return. If not specified, all fields (own_follows, own_followings, own_capabilities, own_membership) are returned
    public var fields: [String]?

    public init(feeds: [String], fields: [String]? = nil) {
        self.feeds = feeds
        self.fields = fields
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case feeds
        case fields
    }
}

extension OwnBatchRequest: Hashable {
    public static func == (lhs: OwnBatchRequest, rhs: OwnBatchRequest) -> Bool {
        lhs.feeds == rhs.feeds &&
            lhs.fields == rhs.fields
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(feeds)
        hasher.combine(fields)
    }
}
