//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension DeleteBookmarkResponse {
    static func dummy(
        bookmark: BookmarkResponse = .dummy()
    ) -> DeleteBookmarkResponse {
        DeleteBookmarkResponse(
            bookmark: bookmark
        )
    }
}
