//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Options to control fetching reactions from friends (users you follow or have mutual follows with).
public final class FriendReactionsOptions: @unchecked Sendable, Codable, JSONEncodable {
    public enum FriendReactionsOptionsType: String, Sendable, Codable, CaseIterable {
        case following
        case mutual
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

    /// Default: false. When true, fetches friend reactions for activities.
    public var enabled: Bool?
    /// Default: 3, Max: 10. The maximum number of friend reactions to return per activity.
    public var limit: Int?
    /// Default: 'following'. The type of friend relationship to use. 'following' = users you follow, 'mutual' = users with mutual follows. One of: following, mutual
    public var type: FriendReactionsOptionsType?

    public init(enabled: Bool? = nil, limit: Int? = nil) {
        self.enabled = enabled
        self.limit = limit
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case enabled
        case limit
        case type
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
