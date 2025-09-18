//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension DeleteCommentResponse {
    static func dummy(
        activity: ActivityResponse = .dummy(),
        comment: CommentResponse = .dummy(),
        duration: String = "1.23ms"
    ) -> DeleteCommentResponse {
        DeleteCommentResponse(
            activity: activity,
            comment: comment,
            duration: duration
        )
    }
}
