//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UpdateCollectionRequest: Sendable, Encodable, JSONEncodable {
    /// Custom data for the collection (required, must contain at least one key)
    public let custom: [String: RawJSON]
    /// Unique identifier for the collection within its name
    public let id: String
    /// Name/type of the collection
    public let name: String

    public init(custom: [String: RawJSON], id: String, name: String) {
        self.custom = custom
        self.id = id
        self.name = name
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(custom, forKey: .custom)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
    }
}

extension UpdateCollectionRequest: Hashable {
    public static func == (lhs: UpdateCollectionRequest, rhs: UpdateCollectionRequest) -> Bool {
        lhs.custom == rhs.custom &&
            lhs.id == rhs.id &&
            lhs.name == rhs.name
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(custom)
        hasher.combine(id)
        hasher.combine(name)
    }
}
