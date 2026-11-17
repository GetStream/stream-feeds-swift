//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension UpdateFeedResponse {
    static func dummy(
        feed: FeedResponse = .dummy()
    ) -> UpdateFeedResponse {
        UpdateFeedResponse(
            feed: feed
        )
    }
}
