//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension BookmarkUpdatedEvent {
    static func dummy(
        bookmark: BookmarkResponse = BookmarkResponse.dummy(),
        fid: String,
        user: UserResponseCommonFields? = UserResponseCommonFields.dummy()
    ) -> BookmarkUpdatedEvent {
        BookmarkUpdatedEvent(
            bookmark: bookmark,
            createdAt: Date.fixed(),
            custom: [:],
            receivedAt: Date.fixed(),
            user: user
        )
    }
}
