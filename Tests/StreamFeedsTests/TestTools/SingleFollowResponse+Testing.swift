//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension SingleFollowResponse {
    static func dummy(
        duration: String = "1.23ms",
        follow: FollowResponse = .dummy()
    ) -> SingleFollowResponse {
        SingleFollowResponse(
            duration: duration,
            follow: follow
        )
    }
}
