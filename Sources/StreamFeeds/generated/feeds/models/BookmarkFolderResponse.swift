//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class BookmarkFolderResponse: Sendable, Codable, JSONEncodable {
    /// When the folder was created
    public let createdAt: Date
    /// Custom data for the folder
    public let custom: [String: RawJSON]?
    /// Unique identifier for the folder
    public let id: String
    /// Name of the folder
    public let name: String
    /// When the folder was last updated
    public let updatedAt: Date

    public init(createdAt: Date, custom: [String: RawJSON]? = nil, id: String, name: String, updatedAt: Date) {
        self.createdAt = createdAt
        self.custom = custom
        self.id = id
        self.name = name
        self.updatedAt = updatedAt
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.custom = try container.decodeIfPresent([String: RawJSON].self, forKey: .custom)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.updatedAt = try container.decode(Date.self, forKey: .updatedAt)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encodeIfPresent(custom, forKey: .custom)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(updatedAt, forKey: .updatedAt)
    }
}

extension BookmarkFolderResponse: Hashable {
    public static func == (lhs: BookmarkFolderResponse, rhs: BookmarkFolderResponse) -> Bool {
        lhs.createdAt == rhs.createdAt &&
            lhs.custom == rhs.custom &&
            lhs.id == rhs.id &&
            lhs.name == rhs.name &&
            lhs.updatedAt == rhs.updatedAt
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(createdAt)
        hasher.combine(custom)
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(updatedAt)
    }
}
