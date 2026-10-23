//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class BookmarkResponse: @unchecked Sendable, Codable, JSONEncodable {
    public var activity: ActivityResponse
    public var activityId: String?
    public var comment: CommentResponse?
    /// When the bookmark was created
    public var createdAt: Date
    /// Custom data for the bookmark
    public var custom: [String: RawJSON]?
    public var folder: BookmarkFolderResponse?
    /// ID of the bookmarked object
    public var objectId: String
    /// Type of the bookmarked object (activity or comment)
    public var objectType: String
    /// When the bookmark was last updated
    public var updatedAt: Date
    /// User response object
    public var user: UserResponse

    public init(activity: ActivityResponse, activityId: String? = nil, comment: CommentResponse? = nil, createdAt: Date, custom: [String: RawJSON]? = nil, folder: BookmarkFolderResponse? = nil, objectId: String, objectType: String, updatedAt: Date, user: UserResponse) {
        self.activity = activity
        self.activityId = activityId
        self.comment = comment
        self.createdAt = createdAt
        self.custom = custom
        self.folder = folder
        self.objectId = objectId
        self.objectType = objectType
        self.updatedAt = updatedAt
        self.user = user
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case activity
        case activityId = "activity_id"
        case comment
        case createdAt = "created_at"
        case custom
        case folder
        case objectId = "object_id"
        case objectType = "object_type"
        case updatedAt = "updated_at"
        case user
    }
}

extension BookmarkResponse: Hashable {
    public static func == (lhs: BookmarkResponse, rhs: BookmarkResponse) -> Bool {
        lhs.activity == rhs.activity &&
            lhs.activityId == rhs.activityId &&
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
        hasher.combine(activityId)
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
