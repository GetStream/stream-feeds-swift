//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension DeleteCommentReactionResponse {
    static func dummy(
        comment: CommentResponse = .dummy(),
        duration: String = "1.23ms",
        reaction: FeedsReactionResponse = .dummy()
    ) -> DeleteCommentReactionResponse {
        DeleteCommentReactionResponse(
            comment: comment,
            duration: duration,
            reaction: reaction
        )
    }
}
