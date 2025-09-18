//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension BookmarkDeletedEvent {
    static func dummy(
        bookmark: BookmarkResponse = BookmarkResponse.dummy(),
        fid: String,
        user: UserResponseCommonFields? = UserResponseCommonFields.dummy()
    ) -> BookmarkDeletedEvent {
        BookmarkDeletedEvent(
            bookmark: bookmark,
            createdAt: Date.fixed(),
            custom: [:],
            receivedAt: Date.fixed(),
            user: user
        )
    }
}
