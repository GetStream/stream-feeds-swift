//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class QueryCommentReactionsResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var duration: String
    public var next: String?
    public var prev: String?
    public var reactions: [FeedsReactionResponse]

    public init(duration: String, next: String? = nil, prev: String? = nil, reactions: [FeedsReactionResponse]) {
        self.duration = duration
        self.next = next
        self.prev = prev
        self.reactions = reactions
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case duration
        case next
        case prev
        case reactions
    }

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
