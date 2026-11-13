//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension GetCommentsResponse {
    static func dummy(
        comments: [ThreadedCommentResponse],
        next: String? = nil,
        prev: String? = nil
    ) -> GetCommentsResponse {
        GetCommentsResponse(
            comments: comments,
            next: next,
            prev: prev
        )
    }
}
