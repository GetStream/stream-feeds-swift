//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension UpdateFeedResponse {
    static func dummy(
        duration: String = "1.23ms",
        feed: FeedResponse = .dummy()
    ) -> UpdateFeedResponse {
        UpdateFeedResponse(
            duration: duration,
            feed: feed
        )
    }
}
