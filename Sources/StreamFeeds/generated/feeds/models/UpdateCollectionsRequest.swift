//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UpdateCollectionsRequest: Sendable, Encodable, JSONEncodable {
    /// List of collections to update (only custom data is updatable)
    public let collections: [UpdateCollectionRequest]

    public init(collections: [UpdateCollectionRequest]) {
        self.collections = collections
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(collections, forKey: .collections)
    }
}

extension UpdateCollectionsRequest: Hashable {
    public static func == (lhs: UpdateCollectionsRequest, rhs: UpdateCollectionsRequest) -> Bool {
        lhs.collections == rhs.collections
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(collections)
    }
}
