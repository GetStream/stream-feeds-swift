//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class FollowBatchRequest: Sendable, Codable, JSONEncodable {
    /// If true, enriches the follow's source_feed and target_feed with own_* fields (own_follows, own_followings, own_capabilities, own_membership). Defaults to false for performance.
    public let enrichOwnFields: Bool?
    /// List of follow relationships to create
    public let follows: [FollowRequest]

    public init(enrichOwnFields: Bool? = nil, follows: [FollowRequest]) {
        self.enrichOwnFields = enrichOwnFields
        self.follows = follows
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.enrichOwnFields = try container.decodeIfPresent(Bool.self, forKey: .enrichOwnFields)
        self.follows = try container.decode([FollowRequest].self, forKey: .follows)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(enrichOwnFields, forKey: .enrichOwnFields)
        try container.encode(follows, forKey: .follows)
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
