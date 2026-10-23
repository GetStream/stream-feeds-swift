//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class EnrichedCollectionResponseStatus: RawRepresentable, Codable, Hashable, Sendable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public static let notfound = EnrichedCollectionResponseStatus(rawValue: "notfound")
    public static let ok = EnrichedCollectionResponseStatus(rawValue: "ok")
}

public final class EnrichedCollectionResponse: Sendable, Codable, JSONEncodable {
    /// When the collection was created
    public let createdAt: Date?
    /// Custom data for the collection
    public let custom: [String: RawJSON]?
    /// Unique identifier for the collection within its name
    public let id: String
    /// Name/type of the collection
    public let name: String
    /// Enrichment status of the collection. One of: ok, notfound
    public let status: EnrichedCollectionResponseStatus
    /// When the collection was last updated
    public let updatedAt: Date?
    /// ID of the user who owns this collection
    public let userId: String?

    public init(createdAt: Date? = nil, custom: [String: RawJSON]? = nil, id: String, name: String, status: EnrichedCollectionResponseStatus, updatedAt: Date? = nil, userId: String? = nil) {
        self.createdAt = createdAt
        self.custom = custom
        self.id = id
        self.name = name
        self.status = status
        self.updatedAt = updatedAt
        self.userId = userId
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.createdAt = try container.decodeIfPresent(Date.self, forKey: .createdAt)
        self.custom = try container.decodeIfPresent([String: RawJSON].self, forKey: .custom)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.status = try container.decode(EnrichedCollectionResponseStatus.self, forKey: .status)
        self.updatedAt = try container.decodeIfPresent(Date.self, forKey: .updatedAt)
        self.userId = try container.decodeIfPresent(String.self, forKey: .userId)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(createdAt, forKey: .createdAt)
        try container.encodeIfPresent(custom, forKey: .custom)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(status, forKey: .status)
        try container.encodeIfPresent(updatedAt, forKey: .updatedAt)
        try container.encodeIfPresent(userId, forKey: .userId)
    }
}

extension EnrichedCollectionResponse: Hashable {
    public static func == (lhs: EnrichedCollectionResponse, rhs: EnrichedCollectionResponse) -> Bool {
        lhs.createdAt == rhs.createdAt &&
            lhs.custom == rhs.custom &&
            lhs.id == rhs.id &&
            lhs.name == rhs.name &&
            lhs.status == rhs.status &&
            lhs.updatedAt == rhs.updatedAt &&
            lhs.userId == rhs.userId
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(createdAt)
        hasher.combine(custom)
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(status)
        hasher.combine(updatedAt)
        hasher.combine(userId)
    }
}
