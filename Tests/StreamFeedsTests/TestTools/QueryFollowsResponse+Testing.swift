//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension QueryFollowsResponse {
    static func dummy(
        duration: String = "0.123s",
        follows: [FollowResponse],
        next: String? = nil,
        prev: String? = nil
    ) -> QueryFollowsResponse {
        QueryFollowsResponse(
            duration: duration,
            follows: follows,
            next: next,
            prev: prev
        )
    }
}
