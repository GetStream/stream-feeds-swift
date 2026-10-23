//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class QueryModerationConfigsResponse: Sendable, Codable, JSONEncodable {
    /// List of moderation configurations
    public let configs: [ConfigResponse]
    public let duration: String
    public let next: String?
    public let prev: String?

    public init(configs: [ConfigResponse], duration: String, next: String? = nil, prev: String? = nil) {
        self.configs = configs
        self.duration = duration
        self.next = next
        self.prev = prev
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.configs = try container.decode([ConfigResponse].self, forKey: .configs)
        self.duration = try container.decode(String.self, forKey: .duration)
        self.next = try container.decodeIfPresent(String.self, forKey: .next)
        self.prev = try container.decodeIfPresent(String.self, forKey: .prev)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(configs, forKey: .configs)
        try container.encode(duration, forKey: .duration)
        try container.encodeIfPresent(next, forKey: .next)
        try container.encodeIfPresent(prev, forKey: .prev)
    }
}

extension QueryModerationConfigsResponse: Hashable {
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
