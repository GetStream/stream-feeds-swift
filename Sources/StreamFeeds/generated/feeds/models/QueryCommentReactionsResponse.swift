//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Basic response information
public final class QueryCommentReactionsResponse: Sendable, Decodable {
    /// Duration of the request in milliseconds
    public let duration: String
    public let next: String?
    public let prev: String?
    public let reactions: [FeedsReactionResponse]

    public init(duration: String, next: String? = nil, prev: String? = nil, reactions: [FeedsReactionResponse]) {
        self.duration = duration
        self.next = next
        self.prev = prev
        self.reactions = reactions
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.duration = try container.decode(String.self, forKey: .duration)
        self.next = try container.decodeIfPresent(String.self, forKey: .next)
        self.prev = try container.decodeIfPresent(String.self, forKey: .prev)
        self.reactions = try container.decode([FeedsReactionResponse].self, forKey: .reactions)
    }
}

extension QueryCommentReactionsResponse: Hashable {
    public static func == (lhs: QueryCommentReactionsResponse, rhs: QueryCommentReactionsResponse) -> Bool {
        lhs.duration == rhs.duration &&
            lhs.next == rhs.next &&
            lhs.prev == rhs.prev &&
            lhs.reactions == rhs.reactions
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(duration)
        hasher.combine(next)
        hasher.combine(prev)
        hasher.combine(reactions)
    }
}
