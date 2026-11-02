//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class PagerRequest: Sendable, Encodable, JSONEncodable {
    public let limit: Int?
    public let next: String?
    public let prev: String?

    public init(limit: Int? = nil, next: String? = nil, prev: String? = nil) {
        self.limit = limit
        self.next = next
        self.prev = prev
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(limit, forKey: .limit)
        try container.encodeIfPresent(next, forKey: .next)
        try container.encodeIfPresent(prev, forKey: .prev)
    }
}

extension PagerRequest: Hashable {
    public static func == (lhs: PagerRequest, rhs: PagerRequest) -> Bool {
        lhs.limit == rhs.limit &&
            lhs.next == rhs.next &&
            lhs.prev == rhs.prev
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(limit)
        hasher.combine(next)
        hasher.combine(prev)
    }
}
