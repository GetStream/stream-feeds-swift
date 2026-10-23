//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class BookmarkFolderResponse: @unchecked Sendable, Codable, JSONEncodable {
    /// When the folder was created
    public var createdAt: Date
    /// Custom data for the folder
    public var custom: [String: RawJSON]?
    /// Unique identifier for the folder
    public var id: String
    /// Name of the folder
    public var name: String
    /// When the folder was last updated
    public var updatedAt: Date
    /// User response object
    public var user: UserResponse

    public init(createdAt: Date, custom: [String: RawJSON]? = nil, id: String, name: String, updatedAt: Date, user: UserResponse) {
        self.createdAt = createdAt
        self.custom = custom
        self.id = id
        self.name = name
        self.updatedAt = updatedAt
        self.user = user
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case createdAt = "created_at"
        case custom
        case id
        case name
        case updatedAt = "updated_at"
        case user
    }
}

extension BookmarkFolderResponse: Hashable {
    public static func == (lhs: BookmarkFolderResponse, rhs: BookmarkFolderResponse) -> Bool {
        lhs.createdAt == rhs.createdAt &&
            lhs.custom == rhs.custom &&
            lhs.id == rhs.id &&
            lhs.name == rhs.name &&
            lhs.updatedAt == rhs.updatedAt &&
            lhs.user == rhs.user
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(createdAt)
        hasher.combine(custom)
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(updatedAt)
        hasher.combine(user)
    }
}
