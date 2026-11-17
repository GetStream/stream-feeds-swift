//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension GetFollowSuggestionsResponse {
    static func dummy(
        suggestions: [FeedSuggestionResponse] = [.dummy()]
    ) -> GetFollowSuggestionsResponse {
        GetFollowSuggestionsResponse(
            suggestions: suggestions
        )
    }
}
