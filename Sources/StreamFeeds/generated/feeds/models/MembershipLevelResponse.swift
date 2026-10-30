//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class MembershipLevelResponse: Sendable, Decodable {
    /// When the membership level was created
    public let createdAt: Date
    /// Custom data for the membership level
    public let custom: [String: RawJSON]?
    /// Description of the membership level
    public let description: String?
    /// Unique identifier for the membership level
    public let id: String
    /// Display name for the membership level
    public let name: String
    /// Priority level
    public let priority: Int
    /// Activity tags this membership level gives access to
    public let tags: [String]
    /// When the membership level was last updated
    public let updatedAt: Date

    public init(createdAt: Date, custom: [String: RawJSON]? = nil, description: String? = nil, id: String, name: String, priority: Int, tags: [String], updatedAt: Date) {
        self.createdAt = createdAt
        self.custom = custom
        self.description = description
        self.id = id
        self.name = name
        self.priority = priority
        self.tags = tags
        self.updatedAt = updatedAt
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.custom = try container.decodeIfPresent([String: RawJSON].self, forKey: .custom)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.priority = try container.decode(Int.self, forKey: .priority)
        self.tags = try container.decode([String].self, forKey: .tags)
        self.updatedAt = try container.decode(Date.self, forKey: .updatedAt)
    }
}

extension MembershipLevelResponse: Hashable {
    public static func == (lhs: MembershipLevelResponse, rhs: MembershipLevelResponse) -> Bool {
        lhs.createdAt == rhs.createdAt &&
            lhs.custom == rhs.custom &&
            lhs.description == rhs.description &&
            lhs.id == rhs.id &&
            lhs.name == rhs.name &&
            lhs.priority == rhs.priority &&
            lhs.tags == rhs.tags &&
            lhs.updatedAt == rhs.updatedAt
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(createdAt)
        hasher.combine(custom)
        hasher.combine(description)
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(priority)
        hasher.combine(tags)
        hasher.combine(updatedAt)
    }
}
