//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension BookmarkDeletedEvent {
    static func dummy(
        bookmark: BookmarkResponse = .dummy(),
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
