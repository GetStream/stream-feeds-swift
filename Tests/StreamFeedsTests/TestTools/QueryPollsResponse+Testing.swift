//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension QueryPollsResponse {
    static func dummy(
        polls: [PollResponseData],
        next: String? = nil,
        prev: String? = nil
    ) -> QueryPollsResponse {
        QueryPollsResponse(
            next: next,
            polls: polls,
            prev: prev
        )
    }
}
