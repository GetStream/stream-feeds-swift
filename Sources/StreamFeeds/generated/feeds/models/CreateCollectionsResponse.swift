//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class CreateCollectionsResponse: Sendable, Decodable {
    /// List of created collections
    public let collections: [CollectionResponse]

    public init(collections: [CollectionResponse]) {
        self.collections = collections
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.collections = try container.decode([CollectionResponse].self, forKey: .collections)
    }
}

extension CreateCollectionsResponse: Hashable {
    public static func == (lhs: CreateCollectionsResponse, rhs: CreateCollectionsResponse) -> Bool {
        lhs.collections == rhs.collections
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(collections)
    }
}
