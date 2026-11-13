//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class QueryCollectionsResponse: Sendable, Decodable {
    /// List of collections matching the query
    public let collections: [CollectionResponse]
    public let duration: String
    /// Cursor for next page
    public let next: String?
    /// Cursor for previous page
    public let prev: String?

    public init(collections: [CollectionResponse], duration: String, next: String? = nil, prev: String? = nil) {
        self.collections = collections
        self.duration = duration
        self.next = next
        self.prev = prev
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.collections = try container.decode([CollectionResponse].self, forKey: .collections)
        self.duration = try container.decode(String.self, forKey: .duration)
        self.next = try container.decodeIfPresent(String.self, forKey: .next)
        self.prev = try container.decodeIfPresent(String.self, forKey: .prev)
    }
}

extension QueryCollectionsResponse: Hashable {
    public static func == (lhs: QueryCollectionsResponse, rhs: QueryCollectionsResponse) -> Bool {
        lhs.collections == rhs.collections &&
            lhs.duration == rhs.duration &&
            lhs.next == rhs.next &&
            lhs.prev == rhs.prev
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(collections)
        hasher.combine(duration)
        hasher.combine(next)
        hasher.combine(prev)
    }
}
