//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension QueryPollsResponse {
    static func dummy(
        duration: String = "0.123s",
        polls: [PollResponseData],
        next: String? = nil,
        prev: String? = nil
    ) -> QueryPollsResponse {
        QueryPollsResponse(
            duration: duration,
            next: next,
            polls: polls,
            prev: prev
        )
    }
}
