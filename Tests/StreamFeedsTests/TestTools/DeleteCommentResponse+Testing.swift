//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension DeleteCommentResponse {
    static func dummy(
        activity: ActivityResponse,
        comment: CommentResponse
    ) -> DeleteCommentResponse {
        DeleteCommentResponse(
            activity: activity,
            comment: comment
        )
    }
}
