//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Basic response information
public final class ListBlockListResponse: Sendable, Codable, JSONEncodable {
    public let blocklists: [BlockListResponse]
    /// Duration of the request in milliseconds
    public let duration: String
    public let nextCursor: String?

    public init(blocklists: [BlockListResponse], duration: String, nextCursor: String? = nil) {
        self.blocklists = blocklists
        self.duration = duration
        self.nextCursor = nextCursor
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.blocklists = try container.decode([BlockListResponse].self, forKey: .blocklists)
        self.duration = try container.decode(String.self, forKey: .duration)
        self.nextCursor = try container.decodeIfPresent(String.self, forKey: .nextCursor)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(blocklists, forKey: .blocklists)
        try container.encode(duration, forKey: .duration)
        try container.encodeIfPresent(nextCursor, forKey: .nextCursor)
    }
}

extension ListBlockListResponse: Hashable {
    public static func == (lhs: ListBlockListResponse, rhs: ListBlockListResponse) -> Bool {
        lhs.blocklists == rhs.blocklists &&
            lhs.duration == rhs.duration &&
            lhs.nextCursor == rhs.nextCursor
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(blocklists)
        hasher.combine(duration)
        hasher.combine(nextCursor)
    }
}
