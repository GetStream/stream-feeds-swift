//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension AddBookmarkResponse {
    static func dummy(
        bookmark: BookmarkResponse = .dummy(),
        duration: String = "1.23ms"
    ) -> AddBookmarkResponse {
        AddBookmarkResponse(
            bookmark: bookmark,
            duration: duration
        )
    }
}
