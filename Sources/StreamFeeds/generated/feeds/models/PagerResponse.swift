//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class PagerResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var next: String?
    public var prev: String?

    public init(next: String? = nil, prev: String? = nil) {
        self.next = next
        self.prev = prev
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case next
        case prev
    }

    public static func == (lhs: PagerResponse, rhs: PagerResponse) -> Bool {
        lhs.next == rhs.next &&
            lhs.prev == rhs.prev
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(next)
        hasher.combine(prev)
    }
}
