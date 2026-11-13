//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class CreateCollectionsRequest: Sendable, Encodable, JSONEncodable {
    /// List of collections to create
    public let collections: [CollectionRequest]

    public init(collections: [CollectionRequest]) {
        self.collections = collections
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(collections, forKey: .collections)
    }
}

extension CreateCollectionsRequest: Hashable {
    public static func == (lhs: CreateCollectionsRequest, rhs: CreateCollectionsRequest) -> Bool {
        lhs.collections == rhs.collections
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(collections)
    }
}
