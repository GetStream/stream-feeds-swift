//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension QueryCommentsResponse {
    static func dummy(
        comments: [CommentResponse],
        next: String? = nil,
        prev: String? = nil
    ) -> QueryCommentsResponse {
        QueryCommentsResponse(
            comments: comments,
            next: next,
            prev: prev
        )
    }
}
