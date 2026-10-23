//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class PagerResponse: Sendable, Decodable {
    public let next: String?
    public let prev: String?

    public init(next: String? = nil, prev: String? = nil) {
        self.next = next
        self.prev = prev
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.next = try container.decodeIfPresent(String.self, forKey: .next)
        self.prev = try container.decodeIfPresent(String.self, forKey: .prev)
    }
}

extension PagerResponse: Hashable {
    public static func == (lhs: PagerResponse, rhs: PagerResponse) -> Bool {
        lhs.next == rhs.next &&
            lhs.prev == rhs.prev
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(next)
        hasher.combine(prev)
    }
}
