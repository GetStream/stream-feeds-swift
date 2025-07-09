//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class BookmarkResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var activity: ActivityResponse
    public var createdAt: Date
    public var custom: [String: RawJSON]?
    public var folder: BookmarkFolderResponse?
    public var updatedAt: Date
    public var user: UserResponse

    public init(activity: ActivityResponse, createdAt: Date, custom: [String: RawJSON]? = nil, folder: BookmarkFolderResponse? = nil, updatedAt: Date, user: UserResponse) {
        self.activity = activity
        self.createdAt = createdAt
        self.custom = custom
        self.folder = folder
        self.updatedAt = updatedAt
        self.user = user
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case activity
        case createdAt = "created_at"
        case custom
        case folder
        case updatedAt = "updated_at"
        case user
    }

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
