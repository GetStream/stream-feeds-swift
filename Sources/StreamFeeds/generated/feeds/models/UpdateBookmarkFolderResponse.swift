//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UpdateBookmarkFolderResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var bookmarkFolder: BookmarkFolderResponse
    public var duration: String

    public init(bookmarkFolder: BookmarkFolderResponse, duration: String) {
        self.bookmarkFolder = bookmarkFolder
        self.duration = duration
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case bookmarkFolder = "bookmark_folder"
        case duration
    }

    public static func == (lhs: UpdateBookmarkFolderResponse, rhs: UpdateBookmarkFolderResponse) -> Bool {
        lhs.bookmarkFolder == rhs.bookmarkFolder &&
            lhs.duration == rhs.duration
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(bookmarkFolder)
        hasher.combine(duration)
    }
}
