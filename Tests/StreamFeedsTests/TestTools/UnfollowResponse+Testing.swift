//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension UnfollowResponse {
    static func dummy(
        follow: FollowResponse = .dummy()
    ) -> UnfollowResponse {
        UnfollowResponse(
            follow: follow
        )
    }
}
