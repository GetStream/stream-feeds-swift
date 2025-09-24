//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension QueryActivityReactionsResponse {
    static func dummy(
        reactions: [FeedsReactionResponse],
        duration: String = "0.123s",
        next: String? = nil,
        prev: String? = nil
    ) -> QueryActivityReactionsResponse {
        QueryActivityReactionsResponse(
            duration: duration,
            next: next,
            prev: prev,
            reactions: reactions
        )
    }
}
