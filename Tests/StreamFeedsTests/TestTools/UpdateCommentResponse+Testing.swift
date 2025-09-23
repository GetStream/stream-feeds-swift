//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension UpdateCommentResponse {
    static func dummy(
        comment: CommentResponse,
        duration: String = "1.23ms"
    ) -> UpdateCommentResponse {
        UpdateCommentResponse(
            comment: comment,
            duration: duration
        )
    }
}
