//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class MembershipLevelResponse: @unchecked Sendable, Codable, JSONEncodable {
    /// When the membership level was created
    public var createdAt: Date
    /// Custom data for the membership level
    public var custom: [String: RawJSON]?
    /// Description of the membership level
    public var description: String?
    /// Unique identifier for the membership level
    public var id: String
    /// Display name for the membership level
    public var name: String
    /// Priority level
    public var priority: Int
    /// Activity tags this membership level gives access to
    public var tags: [String]
    /// When the membership level was last updated
    public var updatedAt: Date

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

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case createdAt = "created_at"
        case custom
        case description
        case id
        case name
        case priority
        case tags
        case updatedAt = "updated_at"
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
