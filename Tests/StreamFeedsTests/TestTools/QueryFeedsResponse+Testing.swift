//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension QueryFeedsResponse {
    static func dummy(
        duration: String = "1.23ms",
        feeds: [FeedResponse] = [],
        next: String? = nil,
        prev: String? = nil
    ) -> QueryFeedsResponse {
        QueryFeedsResponse(
            duration: duration,
            feeds: feeds,
            next: next,
            prev: prev
        )
    }
}
