//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension TranslateCommentResponse {
    static func dummy(
        comment: CommentResponse,
        duration: String = "0.123s"
    ) -> TranslateCommentResponse {
        TranslateCommentResponse(
            comment: comment,
            duration: duration
        )
    }
}
