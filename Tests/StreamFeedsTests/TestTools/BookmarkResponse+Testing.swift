//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension BookmarkResponse {
    static func dummy(
        activity: ActivityResponse = .dummy(),
        createdAt: Date = .fixed(),
        custom: [String: RawJSON]? = nil,
        folder: BookmarkFolderResponse? = nil,
        updatedAt: Date = .fixed(),
        user: UserResponse = .dummy()
    ) -> BookmarkResponse {
        BookmarkResponse(
            activity: activity,
            createdAt: createdAt,
            custom: custom,
            folder: folder,
            updatedAt: updatedAt,
            user: user
        )
    }
}
