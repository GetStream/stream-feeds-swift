//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Emitted when a bookmark folder is deleted.
public final class BookmarkFolderDeletedEvent: @unchecked Sendable, Event, Codable, JSONEncodable {
    public var bookmarkFolder: BookmarkFolderResponse
    /// Date/time of creation
    public var createdAt: Date
    public var custom: [String: RawJSON]
    public var receivedAt: Date?
    /// The type of event: "feeds.bookmark_folder.deleted" in this case
    public var type: String = "feeds.bookmark_folder.deleted"
    public var user: UserResponseCommonFields?

    public init(bookmarkFolder: BookmarkFolderResponse, createdAt: Date, custom: [String: RawJSON], receivedAt: Date? = nil, user: UserResponseCommonFields? = nil) {
        self.bookmarkFolder = bookmarkFolder
        self.createdAt = createdAt
        self.custom = custom
        self.receivedAt = receivedAt
        self.user = user
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case bookmarkFolder = "bookmark_folder"
        case createdAt = "created_at"
        case custom
        case receivedAt = "received_at"
        case type
        case user
    }
}

extension BookmarkFolderDeletedEvent: Hashable {
    public static func == (lhs: BookmarkFolderDeletedEvent, rhs: BookmarkFolderDeletedEvent) -> Bool {
        lhs.bookmarkFolder == rhs.bookmarkFolder &&
            lhs.createdAt == rhs.createdAt &&
            lhs.custom == rhs.custom &&
            lhs.receivedAt == rhs.receivedAt &&
            lhs.type == rhs.type &&
            lhs.user == rhs.user
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(bookmarkFolder)
        hasher.combine(createdAt)
        hasher.combine(custom)
        hasher.combine(receivedAt)
        hasher.combine(type)
        hasher.combine(user)
    }
}
