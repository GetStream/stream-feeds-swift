//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension BookmarkFolderDeletedEvent {
    static func dummy(
        bookmarkFolder: BookmarkFolderResponse = .dummy(),
        createdAt: Date = .fixed(),
        custom: [String: RawJSON] = [:],
        receivedAt: Date? = nil,
        user: UserResponseCommonFields? = nil
    ) -> BookmarkFolderDeletedEvent {
        BookmarkFolderDeletedEvent(
            bookmarkFolder: bookmarkFolder,
            createdAt: createdAt,
            custom: custom,
            receivedAt: receivedAt,
            user: user
        )
    }
}
