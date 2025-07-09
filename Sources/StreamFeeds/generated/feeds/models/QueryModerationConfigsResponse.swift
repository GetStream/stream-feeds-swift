//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class QueryModerationConfigsResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var configs: [ConfigResponse]
    public var duration: String
    public var next: String?
    public var prev: String?

    public init(configs: [ConfigResponse], duration: String, next: String? = nil, prev: String? = nil) {
        self.configs = configs
        self.duration = duration
        self.next = next
        self.prev = prev
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case configs
        case duration
        case next
        case prev
    }

    public static func == (lhs: QueryModerationConfigsResponse, rhs: QueryModerationConfigsResponse) -> Bool {
        lhs.configs == rhs.configs &&
            lhs.duration == rhs.duration &&
            lhs.next == rhs.next &&
            lhs.prev == rhs.prev
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(configs)
        hasher.combine(duration)
        hasher.combine(next)
        hasher.combine(prev)
    }
}
