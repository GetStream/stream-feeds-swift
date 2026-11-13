//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension GetCommentRepliesResponse {
    static func dummy(
        comments: [ThreadedCommentResponse],
        next: String? = nil,
        prev: String? = nil
    ) -> GetCommentRepliesResponse {
        GetCommentRepliesResponse(
            comments: comments,
            next: next,
            prev: prev
        )
    }
}
