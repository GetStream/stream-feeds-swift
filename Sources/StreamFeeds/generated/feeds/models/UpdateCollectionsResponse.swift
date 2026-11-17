//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UpdateCollectionsResponse: Sendable, Decodable {
    /// List of updated collections
    public let collections: [CollectionResponse]

    public init(collections: [CollectionResponse]) {
        self.collections = collections
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.collections = try container.decode([CollectionResponse].self, forKey: .collections)
    }
}

extension UpdateCollectionsResponse: Hashable {
    public static func == (lhs: UpdateCollectionsResponse, rhs: UpdateCollectionsResponse) -> Bool {
        lhs.collections == rhs.collections
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(collections)
    }
}
