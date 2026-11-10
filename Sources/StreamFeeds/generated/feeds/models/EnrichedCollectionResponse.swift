//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class EnrichedCollectionResponse: Sendable, Decodable {
    public let collection: CollectionResponse
    /// Enrichment status of the collection. One of: ok, notfound
    public let status: CollectionStatus

    public init(collection: CollectionResponse, status: CollectionStatus) {
        self.collection = collection
        self.status = status
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.collection = try CollectionResponse(from: decoder)
        self.status = try container.decode(CollectionStatus.self, forKey: .status)
    }
}

extension EnrichedCollectionResponse: Hashable {
    public static func == (lhs: EnrichedCollectionResponse, rhs: EnrichedCollectionResponse) -> Bool {
        lhs.collection == rhs.collection &&
            lhs.status == rhs.status
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(collection)
        hasher.combine(status)
    }
}
