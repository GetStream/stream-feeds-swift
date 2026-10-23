//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class BookmarkResponse: Sendable, Codable, JSONEncodable {
    public let activity: ActivityResponse
    /// When the bookmark was created
    public let createdAt: Date
    /// Custom data for the bookmark
    public let custom: [String: RawJSON]?
    public let folder: BookmarkFolderResponse?
    /// When the bookmark was last updated
    public let updatedAt: Date
    /// User response object
    public let user: UserResponse

    public init(activity: ActivityResponse, createdAt: Date, custom: [String: RawJSON]? = nil, folder: BookmarkFolderResponse? = nil, updatedAt: Date, user: UserResponse) {
        self.activity = activity
        self.createdAt = createdAt
        self.custom = custom
        self.folder = folder
        self.updatedAt = updatedAt
        self.user = user
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.activity = try container.decode(ActivityResponse.self, forKey: .activity)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.custom = try container.decodeIfPresent([String: RawJSON].self, forKey: .custom)
        self.folder = try container.decodeIfPresent(BookmarkFolderResponse.self, forKey: .folder)
        self.updatedAt = try container.decode(Date.self, forKey: .updatedAt)
        self.user = try container.decode(UserResponse.self, forKey: .user)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(activity, forKey: .activity)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encodeIfPresent(custom, forKey: .custom)
        try container.encodeIfPresent(folder, forKey: .folder)
        try container.encode(updatedAt, forKey: .updatedAt)
        try container.encode(user, forKey: .user)
    }
}

extension BookmarkResponse: Hashable {
    public static func == (lhs: BookmarkResponse, rhs: BookmarkResponse) -> Bool {
        lhs.activity == rhs.activity &&
            lhs.createdAt == rhs.createdAt &&
            lhs.custom == rhs.custom &&
            lhs.folder == rhs.folder &&
            lhs.updatedAt == rhs.updatedAt &&
            lhs.user == rhs.user
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(activity)
        hasher.combine(createdAt)
        hasher.combine(custom)
        hasher.combine(folder)
        hasher.combine(updatedAt)
        hasher.combine(user)
    }
}
