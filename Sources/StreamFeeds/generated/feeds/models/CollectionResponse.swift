//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class CollectionResponse: Sendable, Decodable {
    /// When the collection was created
    public let createdAt: Date?
    /// Custom data for the collection
    public let custom: [String: RawJSON]?
    /// Unique identifier for the collection within its name
    public let id: String
    /// Name/type of the collection
    public let name: String
    /// When the collection was last updated
    public let updatedAt: Date?
    /// ID of the user who owns this collection
    public let userId: String?

    public init(createdAt: Date? = nil, custom: [String: RawJSON]? = nil, id: String, name: String, updatedAt: Date? = nil, userId: String? = nil) {
        self.createdAt = createdAt
        self.custom = custom
        self.id = id
        self.name = name
        self.updatedAt = updatedAt
        self.userId = userId
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.createdAt = try container.decodeIfPresent(Date.self, forKey: .createdAt)
        self.custom = try container.decodeIfPresent([String: RawJSON].self, forKey: .custom)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.updatedAt = try container.decodeIfPresent(Date.self, forKey: .updatedAt)
        self.userId = try container.decodeIfPresent(String.self, forKey: .userId)
    }
}

extension CollectionResponse: Hashable {
    public static func == (lhs: CollectionResponse, rhs: CollectionResponse) -> Bool {
        lhs.createdAt == rhs.createdAt &&
            lhs.custom == rhs.custom &&
            lhs.id == rhs.id &&
            lhs.name == rhs.name &&
            lhs.updatedAt == rhs.updatedAt &&
            lhs.userId == rhs.userId
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(createdAt)
        hasher.combine(custom)
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(updatedAt)
        hasher.combine(userId)
    }
}
