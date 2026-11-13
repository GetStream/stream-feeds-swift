//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Options to control fetching reactions from friends (users you follow or have mutual follows with).
public final class FriendReactionsOptions: Sendable, Encodable, JSONEncodable {
    /// Default: false. When true, fetches friend reactions for activities.
    public let enabled: Bool?
    /// Default: 3, Max: 10. The maximum number of friend reactions to return per activity.
    public let limit: Int?
    /// Default: 'following'. The type of friend relationship to use. 'following' = users you follow, 'mutual' = users with mutual follows. One of: following, mutual
    public let type: FriendReactionType?

    public init(enabled: Bool? = nil, limit: Int? = nil, type: FriendReactionType? = nil) {
        self.enabled = enabled
        self.limit = limit
        self.type = type
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(enabled, forKey: .enabled)
        try container.encodeIfPresent(limit, forKey: .limit)
        try container.encodeIfPresent(type, forKey: .type)
    }
}

extension FriendReactionsOptions: Hashable {
    public static func == (lhs: FriendReactionsOptions, rhs: FriendReactionsOptions) -> Bool {
        lhs.enabled == rhs.enabled &&
            lhs.limit == rhs.limit &&
            lhs.type == rhs.type
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(enabled)
        hasher.combine(limit)
        hasher.combine(type)
    }
}
