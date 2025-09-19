//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension AcceptFollowResponse {
    static func dummy(
        duration: String = "1.23ms",
        follow: FollowResponse = .dummy()
    ) -> AcceptFollowResponse {
        AcceptFollowResponse(
            duration: duration,
            follow: follow
        )
    }
}
