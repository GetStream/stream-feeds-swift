//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension SingleFollowResponse {
    static func dummy(
        follow: FollowResponse = .dummy()
    ) -> SingleFollowResponse {
        SingleFollowResponse(
            follow: follow
        )
    }
}
