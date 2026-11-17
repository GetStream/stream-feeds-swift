//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension UpdateCommentResponse {
    static func dummy(
        comment: CommentResponse
    ) -> UpdateCommentResponse {
        UpdateCommentResponse(
            comment: comment
        )
    }
}
