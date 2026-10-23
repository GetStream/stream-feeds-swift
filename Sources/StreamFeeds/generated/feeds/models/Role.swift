//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class Role: @unchecked Sendable, Codable, JSONEncodable {
    /// Date/time of creation
    public var createdAt: Date
    /// Whether this is a custom role or built-in
    public var custom: Bool
    /// Unique role name
    public var name: String
    /// List of scopes where this role is currently present. `.app` means that role is present in app-level grants
    public var scopes: [String]
    /// Date/time of the last update
    public var updatedAt: Date

    public init(createdAt: Date, custom: Bool, name: String, scopes: [String], updatedAt: Date) {
        self.createdAt = createdAt
        self.custom = custom
        self.name = name
        self.scopes = scopes
        self.updatedAt = updatedAt
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case createdAt = "created_at"
        case custom
        case name
        case scopes
        case updatedAt = "updated_at"
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
