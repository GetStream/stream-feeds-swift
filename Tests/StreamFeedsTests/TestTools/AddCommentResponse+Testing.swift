//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension AddCommentResponse {
    static func dummy(
        comment: CommentResponse
    ) -> AddCommentResponse {
        AddCommentResponse(
            comment: comment
        )
    }
}
