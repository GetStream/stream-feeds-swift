//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension TranslateCommentResponse {
    static func dummy(
        comment: CommentResponse
    ) -> TranslateCommentResponse {
        TranslateCommentResponse(
            comment: comment
        )
    }
}
