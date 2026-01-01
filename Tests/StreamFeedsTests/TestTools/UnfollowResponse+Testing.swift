//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension UnfollowResponse {
    static func dummy(
        duration: String = "1.23ms",
        follow: FollowResponse = .dummy()
    ) -> UnfollowResponse {
        UnfollowResponse(
            duration: duration,
            follow: follow
        )
    }
}
