//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class CollectionRequest: @unchecked Sendable, Codable, JSONEncodable {
    /// Custom data for the collection (required, must contain at least one key)
    public var custom: [String: RawJSON]
    /// Unique identifier for the collection within its name (optional, will be auto-generated if not provided)
    public var id: String?
    /// Name/type of the collection
    public var name: String

    public init(custom: [String: RawJSON], id: String? = nil, name: String) {
        self.custom = custom
        self.id = id
        self.name = name
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case custom
        case id
        case name
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
