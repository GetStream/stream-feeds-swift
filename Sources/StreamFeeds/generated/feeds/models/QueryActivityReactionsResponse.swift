//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Basic response information
public final class QueryActivityReactionsResponse: Sendable, Decodable {
    public let next: String?
    public let prev: String?
    public let reactions: [FeedsReactionResponse]

    public init(next: String? = nil, prev: String? = nil, reactions: [FeedsReactionResponse]) {
        self.next = next
        self.prev = prev
        self.reactions = reactions
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.next = try container.decodeIfPresent(String.self, forKey: .next)
        self.prev = try container.decodeIfPresent(String.self, forKey: .prev)
        self.reactions = try container.decode([FeedsReactionResponse].self, forKey: .reactions)
    }
}

extension QueryActivityReactionsResponse: Hashable {
    public static func == (lhs: QueryActivityReactionsResponse, rhs: QueryActivityReactionsResponse) -> Bool {
        lhs.next == rhs.next &&
            lhs.prev == rhs.prev &&
            lhs.reactions == rhs.reactions
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(next)
        hasher.combine(prev)
        hasher.combine(reactions)
    }
}
