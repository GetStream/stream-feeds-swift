//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class CollectionRequest: Sendable, Codable, JSONEncodable {
    /// Custom data for the collection (required, must contain at least one key)
    public let custom: [String: RawJSON]
    /// Unique identifier for the collection within its name (optional, will be auto-generated if not provided)
    public let id: String?
    /// Name/type of the collection
    public let name: String

    public init(custom: [String: RawJSON], id: String? = nil, name: String) {
        self.custom = custom
        self.id = id
        self.name = name
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.custom = try container.decode([String: RawJSON].self, forKey: .custom)
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(custom, forKey: .custom)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encode(name, forKey: .name)
    }
}

extension CollectionRequest: Hashable {
    public static func == (lhs: CollectionRequest, rhs: CollectionRequest) -> Bool {
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
