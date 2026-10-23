//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension GetCommentRepliesResponse {
    static func dummy(
        comments: [ThreadedCommentResponse],
        duration: String = "0.123s",
        next: String? = nil,
        prev: String? = nil
    ) -> GetCommentRepliesResponse {
        GetCommentRepliesResponse(
            comments: comments,
            duration: duration,
            next: next,
            prev: prev
        )
    }
}
