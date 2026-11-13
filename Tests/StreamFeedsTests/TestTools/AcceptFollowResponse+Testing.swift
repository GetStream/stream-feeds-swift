//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension AcceptFollowResponse {
    static func dummy(
        follow: FollowResponse = .dummy()
    ) -> AcceptFollowResponse {
        AcceptFollowResponse(
            follow: follow
        )
    }
}
