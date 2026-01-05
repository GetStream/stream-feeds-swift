//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension QueryBookmarksResponse {
    static func dummy(
        bookmarks: [BookmarkResponse] = [.dummy()],
        duration: String = "1.23ms",
        next: String? = nil,
        prev: String? = nil
    ) -> QueryBookmarksResponse {
        QueryBookmarksResponse(
            bookmarks: bookmarks,
            duration: duration,
            next: next,
            prev: prev
        )
    }
}
