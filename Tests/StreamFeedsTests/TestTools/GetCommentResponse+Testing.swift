//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension GetCommentResponse {
    static func dummy(
        comment: CommentResponse,
        duration: String = "1.23ms"
    ) -> GetCommentResponse {
        GetCommentResponse(
            comment: comment,
            duration: duration
        )
    }
}
