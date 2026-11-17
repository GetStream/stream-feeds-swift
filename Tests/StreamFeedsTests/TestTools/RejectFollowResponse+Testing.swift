//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension RejectFollowResponse {
    static func dummy(
        follow: FollowResponse = .dummy()
    ) -> RejectFollowResponse {
        RejectFollowResponse(
            follow: follow
        )
    }
}
