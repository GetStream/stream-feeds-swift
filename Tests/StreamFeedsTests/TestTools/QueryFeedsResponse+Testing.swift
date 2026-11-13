//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension QueryFeedsResponse {
    static func dummy(
        feeds: [FeedResponse] = [],
        next: String? = nil,
        prev: String? = nil
    ) -> QueryFeedsResponse {
        QueryFeedsResponse(
            feeds: feeds,
            next: next,
            prev: prev
        )
    }
}
