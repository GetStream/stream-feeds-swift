//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension DeleteCommentReactionResponse {
    static func dummy(
        comment: CommentResponse,
        duration: String = "1.23ms",
        reaction: FeedsReactionResponse
    ) -> DeleteCommentReactionResponse {
        DeleteCommentReactionResponse(
            comment: comment,
            duration: duration,
            reaction: reaction
        )
    }
}
