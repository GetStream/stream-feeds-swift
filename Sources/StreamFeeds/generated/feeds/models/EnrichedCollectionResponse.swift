//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class EnrichedCollectionResponse: @unchecked Sendable, Codable, JSONEncodable {
    public enum EnrichedCollectionResponseStatus: String, Sendable, Codable, CaseIterable {
        case notfound
        case ok
        case unknown = "_unknown"

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let decodedValue = try? container.decode(String.self),
               let value = Self(rawValue: decodedValue) {
                self = value
            } else {
                self = .unknown
            }
        }
    }

    /// When the collection was created
    public var createdAt: Date?
    /// Custom data for the collection
    public var custom: [String: RawJSON]?
    /// Unique identifier for the collection within its name
    public var id: String
    /// Name/type of the collection
    public var name: String
    /// Enrichment status of the collection. One of: ok, notfound
    public var status: EnrichedCollectionResponseStatus
    /// When the collection was last updated
    public var updatedAt: Date?
    /// ID of the user who owns this collection
    public var userId: String?

    public init(
        createdAt: Date? = nil,
        custom: [String: RawJSON]? = nil,
        id: String,
        name: String,
        status: EnrichedCollectionResponseStatus,
        updatedAt: Date? = nil,
        userId: String? = nil
    ) {
        self.createdAt = createdAt
        self.custom = custom
        self.id = id
        self.name = name
        self.status = status
        self.updatedAt = updatedAt
        self.userId = userId
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case createdAt = "created_at"
        case custom
        case id
        case name
        case status
        case updatedAt = "updated_at"
        case userId = "user_id"
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
