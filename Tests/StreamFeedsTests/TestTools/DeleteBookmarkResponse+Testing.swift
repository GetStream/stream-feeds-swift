//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension DeleteBookmarkResponse {
    static func dummy(
        bookmark: BookmarkResponse = .dummy(),
        duration: String = "1.23ms"
    ) -> DeleteBookmarkResponse {
        DeleteBookmarkResponse(
            bookmark: bookmark,
            duration: duration
        )
    }
}
