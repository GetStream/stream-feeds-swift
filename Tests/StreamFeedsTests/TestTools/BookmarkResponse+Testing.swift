//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension BookmarkResponse {
    static func dummy(
        activity: ActivityResponse = .dummy(),
        comment: CommentResponse? = nil,
        createdAt: Date = .fixed(),
        custom: [String: RawJSON]? = nil,
        folder: BookmarkFolderResponse? = nil,
        updatedAt: Date = .fixed(),
        user: UserResponse = .dummy()
    ) -> BookmarkResponse {
        BookmarkResponse(
            activity: activity,
            comment: comment,
            createdAt: createdAt,
            custom: custom,
            folder: folder,
            objectId: comment?.id ?? activity.id,
            objectType: comment == nil ? "activity" : "comment",
            updatedAt: updatedAt,
            user: user
        )
    }
}
