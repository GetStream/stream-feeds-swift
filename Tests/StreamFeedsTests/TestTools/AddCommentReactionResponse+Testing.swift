//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension AddCommentReactionResponse {
    static func dummy(
        comment: CommentResponse,
        duration: String = "1.23ms",
        reaction: FeedsReactionResponse = .dummy()
    ) -> AddCommentReactionResponse {
        AddCommentReactionResponse(
            comment: comment,
            duration: duration,
            reaction: reaction
        )
    }
}
