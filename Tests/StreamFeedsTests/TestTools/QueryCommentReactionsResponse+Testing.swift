//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension QueryCommentReactionsResponse {
    static func dummy(
        reactions: [FeedsReactionResponse] = [],
        next: String? = nil,
        prev: String? = nil
    ) -> QueryCommentReactionsResponse {
        QueryCommentReactionsResponse(
            next: next,
            prev: prev,
            reactions: reactions
        )
    }
}
