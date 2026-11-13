//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class BookmarkResponse: Sendable, Decodable {
    public let activity: ActivityResponse
    public let comment: CommentResponse?
    /// When the bookmark was created
    public let createdAt: Date
    /// Custom data for the bookmark
    public let custom: [String: RawJSON]?
    public let folder: BookmarkFolderResponse?
    /// ID of the bookmarked object
    public let objectId: String
    /// Type of the bookmarked object (activity or comment)
    public let objectType: String
    /// When the bookmark was last updated
    public let updatedAt: Date
    /// User response object
    public let user: UserResponse

    public init(activity: ActivityResponse, comment: CommentResponse? = nil, createdAt: Date, custom: [String: RawJSON]? = nil, folder: BookmarkFolderResponse? = nil, objectId: String, objectType: String, updatedAt: Date, user: UserResponse) {
        self.activity = activity
        self.comment = comment
        self.createdAt = createdAt
        self.custom = custom
        self.folder = folder
        self.objectId = objectId
        self.objectType = objectType
        self.updatedAt = updatedAt
        self.user = user
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.activity = try container.decode(ActivityResponse.self, forKey: .activity)
        self.comment = try container.decodeIfPresent(CommentResponse.self, forKey: .comment)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.custom = try container.decodeIfPresent([String: RawJSON].self, forKey: .custom)
        self.folder = try container.decodeIfPresent(BookmarkFolderResponse.self, forKey: .folder)
        self.objectId = try container.decode(String.self, forKey: .objectId)
        self.objectType = try container.decode(String.self, forKey: .objectType)
        self.updatedAt = try container.decode(Date.self, forKey: .updatedAt)
        self.user = try container.decode(UserResponse.self, forKey: .user)
    }
}

extension BookmarkResponse: Hashable {
    public static func == (lhs: BookmarkResponse, rhs: BookmarkResponse) -> Bool {
        lhs.activity == rhs.activity &&
            lhs.comment == rhs.comment &&
            lhs.createdAt == rhs.createdAt &&
            lhs.custom == rhs.custom &&
            lhs.folder == rhs.folder &&
            lhs.objectId == rhs.objectId &&
            lhs.objectType == rhs.objectType &&
            lhs.updatedAt == rhs.updatedAt &&
            lhs.user == rhs.user
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(activity)
        hasher.combine(comment)
        hasher.combine(createdAt)
        hasher.combine(custom)
        hasher.combine(folder)
        hasher.combine(objectId)
        hasher.combine(objectType)
        hasher.combine(updatedAt)
        hasher.combine(user)
    }
}
