//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class MembershipLevelResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var createdAt: Date
    public var custom: [String: RawJSON]?
    public var description: String?
    public var id: String
    public var name: String
    public var priority: Int
    public var tags: [String]
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
