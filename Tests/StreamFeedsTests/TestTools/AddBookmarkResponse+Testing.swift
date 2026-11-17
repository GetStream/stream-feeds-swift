//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension AddBookmarkResponse {
    static func dummy(
        bookmark: BookmarkResponse = .dummy()
    ) -> AddBookmarkResponse {
        AddBookmarkResponse(
            bookmark: bookmark
        )
    }
}
