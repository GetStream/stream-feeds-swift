//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UpdateBookmarkFolderResponse: Sendable, Codable, JSONEncodable {
    public let bookmarkFolder: BookmarkFolderResponse
    public let duration: String

    public init(bookmarkFolder: BookmarkFolderResponse, duration: String) {
        self.bookmarkFolder = bookmarkFolder
        self.duration = duration
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.bookmarkFolder = try container.decode(BookmarkFolderResponse.self, forKey: .bookmarkFolder)
        self.duration = try container.decode(String.self, forKey: .duration)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(bookmarkFolder, forKey: .bookmarkFolder)
        try container.encode(duration, forKey: .duration)
    }
}

extension UpdateBookmarkFolderResponse: Hashable {
    public static func == (lhs: UpdateBookmarkFolderResponse, rhs: UpdateBookmarkFolderResponse) -> Bool {
        lhs.bookmarkFolder == rhs.bookmarkFolder &&
            lhs.duration == rhs.duration
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(bookmarkFolder)
        hasher.combine(duration)
    }
}
