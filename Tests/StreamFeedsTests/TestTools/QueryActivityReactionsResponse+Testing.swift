//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension QueryActivityReactionsResponse {
    static func dummy(
        reactions: [FeedsReactionResponse],
        next: String? = nil,
        prev: String? = nil
    ) -> QueryActivityReactionsResponse {
        QueryActivityReactionsResponse(
            next: next,
            prev: prev,
            reactions: reactions
        )
    }
}
