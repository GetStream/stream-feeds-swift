//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class FollowBatchRequest: @unchecked Sendable, Codable, JSONEncodable {
    /// If true, enriches the follow's source_feed and target_feed with own_* fields (own_follows, own_followings, own_capabilities, own_membership). Defaults to false for performance.
    public var enrichOwnFields: Bool?
    /// List of follow relationships to create
    public var follows: [FollowRequest]

    public init(enrichOwnFields: Bool? = nil, follows: [FollowRequest]) {
        self.enrichOwnFields = enrichOwnFields
        self.follows = follows
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case enrichOwnFields = "enrich_own_fields"
        case follows
    }
}

extension FollowBatchRequest: Hashable {
    public static func == (lhs: FollowBatchRequest, rhs: FollowBatchRequest) -> Bool {
        lhs.enrichOwnFields == rhs.enrichOwnFields &&
            lhs.follows == rhs.follows
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(enrichOwnFields)
        hasher.combine(follows)
    }
}
