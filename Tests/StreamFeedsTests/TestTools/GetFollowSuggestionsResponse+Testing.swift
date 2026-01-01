//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension GetFollowSuggestionsResponse {
    static func dummy(
        duration: String = "1.23ms",
        suggestions: [FeedResponse] = [.dummy()]
    ) -> GetFollowSuggestionsResponse {
        GetFollowSuggestionsResponse(
            duration: duration,
            suggestions: suggestions
        )
    }
}
