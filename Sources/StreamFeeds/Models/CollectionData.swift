//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// A collection that activities can reference.
public struct CollectionData: Equatable, Sendable {
    /// The date when the collection was created.
    public let createdAt: Date?
    /// Custom data of the collection.
    public let custom: [String: RawJSON]?
    /// The identifier of the collection, unique within its name.
    public let id: String
    /// The name of the collection.
    public let name: String
    /// The date when the collection was last updated.
    public let updatedAt: Date?
    /// The identifier of the user who owns the collection.
    public let userId: String?
}

// MARK: - Model Conversions

extension CollectionResponse {
    func toModel() -> CollectionData {
        CollectionData(
            createdAt: createdAt,
            custom: custom,
            id: id,
            name: name,
            updatedAt: updatedAt,
            userId: userId
        )
    }
}
