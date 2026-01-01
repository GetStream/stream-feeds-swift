//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension UpdateBookmarkResponse {
    static func dummy(
        bookmark: BookmarkResponse = .dummy(),
        duration: String = "1.23ms"
    ) -> UpdateBookmarkResponse {
        UpdateBookmarkResponse(
            bookmark: bookmark,
            duration: duration
        )
    }
}
