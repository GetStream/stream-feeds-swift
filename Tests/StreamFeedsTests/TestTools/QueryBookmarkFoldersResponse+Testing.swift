//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension QueryBookmarkFoldersResponse {
    static func dummy(
        bookmarkFolders: [BookmarkFolderResponse] = [],
        duration: String = "1.23ms",
        next: String? = nil,
        prev: String? = nil
    ) -> QueryBookmarkFoldersResponse {
        QueryBookmarkFoldersResponse(
            bookmarkFolders: bookmarkFolders,
            duration: duration,
            next: next,
            prev: prev
        )
    }
}
