//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension GetCommentsResponse {
    static func dummy(
        comments: [ThreadedCommentResponse] = [.dummy()],
        next: String? = nil,
        prev: String? = nil,
        duration: String = "0.123s"
    ) -> GetCommentsResponse {
        GetCommentsResponse(
            comments: comments,
            duration: duration,
            next: next,
            prev: prev
        )
    }
}
