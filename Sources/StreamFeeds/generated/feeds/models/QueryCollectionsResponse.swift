//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class QueryCollectionsResponse: Sendable, Decodable {
    /// List of collections matching the query
    public let collections: [CollectionResponse]
    /// Cursor for next page
    public let next: String?
    /// Cursor for previous page
    public let prev: String?

    public init(collections: [CollectionResponse], next: String? = nil, prev: String? = nil) {
        self.collections = collections
        self.next = next
        self.prev = prev
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.collections = try container.decode([CollectionResponse].self, forKey: .collections)
        self.next = try container.decodeIfPresent(String.self, forKey: .next)
        self.prev = try container.decodeIfPresent(String.self, forKey: .prev)
    }
}

extension QueryCollectionsResponse: Hashable {
    public static func == (lhs: QueryCollectionsResponse, rhs: QueryCollectionsResponse) -> Bool {
        lhs.collections == rhs.collections &&
            lhs.next == rhs.next &&
            lhs.prev == rhs.prev
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(collections)
        hasher.combine(next)
        hasher.combine(prev)
    }
}
