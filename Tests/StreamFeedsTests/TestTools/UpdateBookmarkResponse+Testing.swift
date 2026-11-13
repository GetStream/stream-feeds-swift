//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension UpdateBookmarkResponse {
    static func dummy(
        bookmark: BookmarkResponse = .dummy()
    ) -> UpdateBookmarkResponse {
        UpdateBookmarkResponse(
            bookmark: bookmark
        )
    }
}
