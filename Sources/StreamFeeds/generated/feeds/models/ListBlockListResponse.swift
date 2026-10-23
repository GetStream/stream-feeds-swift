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

    public init(blocklists: [BlockListResponse], duration: String) {
        self.blocklists = blocklists
        self.duration = duration
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.blocklists = try container.decode([BlockListResponse].self, forKey: .blocklists)
        self.duration = try container.decode(String.self, forKey: .duration)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(blocklists, forKey: .blocklists)
        try container.encode(duration, forKey: .duration)
    }
}

extension ListBlockListResponse: Hashable {
    public static func == (lhs: ListBlockListResponse, rhs: ListBlockListResponse) -> Bool {
        lhs.blocklists == rhs.blocklists &&
            lhs.duration == rhs.duration
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(blocklists)
        hasher.combine(duration)
    }
}
