//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class FriendReactionsOptionsType: RawRepresentable, Codable, Hashable, Sendable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public static let following = FriendReactionsOptionsType(rawValue: "following")
    public static let mutual = FriendReactionsOptionsType(rawValue: "mutual")
}

/// Options to control fetching reactions from friends (users you follow or have mutual follows with).
public final class FriendReactionsOptions: Sendable, Codable, JSONEncodable {
    /// Default: false. When true, fetches friend reactions for activities.
    public let enabled: Bool?
    /// Default: 3, Max: 10. The maximum number of friend reactions to return per activity.
    public let limit: Int?
    /// Default: 'following'. The type of friend relationship to use. 'following' = users you follow, 'mutual' = users with mutual follows. One of: following, mutual
    public let type: FriendReactionsOptionsType?

    public init(enabled: Bool? = nil, limit: Int? = nil, type: FriendReactionsOptionsType? = nil) {
        self.enabled = enabled
        self.limit = limit
        self.type = type
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.enabled = try container.decodeIfPresent(Bool.self, forKey: .enabled)
        self.limit = try container.decodeIfPresent(Int.self, forKey: .limit)
        self.type = try container.decodeIfPresent(FriendReactionsOptionsType.self, forKey: .type)
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
