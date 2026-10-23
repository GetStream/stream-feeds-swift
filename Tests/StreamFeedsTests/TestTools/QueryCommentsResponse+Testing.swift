//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension QueryCommentsResponse {
    static func dummy(
        comments: [CommentResponse],
        duration: String = "0.123s",
        next: String? = nil,
        prev: String? = nil
    ) -> QueryCommentsResponse {
        QueryCommentsResponse(
            comments: comments,
            duration: duration,
            next: next,
            prev: prev
        )
    }
}
