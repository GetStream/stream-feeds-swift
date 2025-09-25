//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension QueryFeedsResponse {
    static func dummy(
        duration: String = "0.123s",
        feeds: [FeedResponse] = [FeedResponse.dummy()],
        next: String? = "next-cursor",
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
