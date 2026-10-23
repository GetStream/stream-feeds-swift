//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Emitted when a bookmark folder is updated.
public final class BookmarkFolderUpdatedEvent: Sendable, Event, Decodable {
    public let bookmarkFolder: BookmarkFolderResponse
    /// Date/time of creation
    public let createdAt: Date
    public let custom: [String: RawJSON]
    public let receivedAt: Date?
    /// The type of event: "feeds.bookmark_folder.updated" in this case
    public let type: String
    public let user: UserResponseCommonFields?

    public init(bookmarkFolder: BookmarkFolderResponse, createdAt: Date, custom: [String: RawJSON], receivedAt: Date? = nil, type: String = "feeds.bookmark_folder.updated", user: UserResponseCommonFields? = nil) {
        self.bookmarkFolder = bookmarkFolder
        self.createdAt = createdAt
        self.custom = custom
        self.receivedAt = receivedAt
        self.type = type
        self.user = user
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.bookmarkFolder = try container.decode(BookmarkFolderResponse.self, forKey: .bookmarkFolder)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.custom = try container.decode([String: RawJSON].self, forKey: .custom)
        self.receivedAt = try container.decodeIfPresent(Date.self, forKey: .receivedAt)
        self.type = try container.decode(String.self, forKey: .type)
        self.user = try container.decodeIfPresent(UserResponseCommonFields.self, forKey: .user)
    }
}

extension BookmarkFolderUpdatedEvent: Hashable {
    public static func == (lhs: BookmarkFolderUpdatedEvent, rhs: BookmarkFolderUpdatedEvent) -> Bool {
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
