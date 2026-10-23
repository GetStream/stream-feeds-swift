//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class Role: Sendable, Decodable {
    /// Date/time of creation
    public let createdAt: Date
    /// Whether this is a custom role or built-in
    public let custom: Bool
    /// Unique role name
    public let name: String
    /// List of scopes where this role is currently present. `.app` means that role is present in app-level grants
    public let scopes: [String]
    /// Date/time of the last update
    public let updatedAt: Date

    public init(createdAt: Date, custom: Bool, name: String, scopes: [String], updatedAt: Date) {
        self.createdAt = createdAt
        self.custom = custom
        self.name = name
        self.scopes = scopes
        self.updatedAt = updatedAt
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.custom = try container.decode(Bool.self, forKey: .custom)
        self.name = try container.decode(String.self, forKey: .name)
        self.scopes = try container.decode([String].self, forKey: .scopes)
        self.updatedAt = try container.decode(Date.self, forKey: .updatedAt)
    }
}

extension Role: Hashable {
    public static func == (lhs: Role, rhs: Role) -> Bool {
        lhs.createdAt == rhs.createdAt &&
            lhs.custom == rhs.custom &&
            lhs.name == rhs.name &&
            lhs.scopes == rhs.scopes &&
            lhs.updatedAt == rhs.updatedAt
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(createdAt)
        hasher.combine(custom)
        hasher.combine(name)
        hasher.combine(scopes)
        hasher.combine(updatedAt)
    }
}
