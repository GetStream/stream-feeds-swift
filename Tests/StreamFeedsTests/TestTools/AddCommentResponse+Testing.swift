//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension AddCommentResponse {
    static func dummy(
        comment: CommentResponse,
        duration: String = "1.23ms"
    ) -> AddCommentResponse {
        AddCommentResponse(
            comment: comment,
            duration: duration
        )
    }
}
