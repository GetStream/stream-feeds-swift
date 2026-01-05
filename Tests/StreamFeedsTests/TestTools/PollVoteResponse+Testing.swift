//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension PollVoteResponse {
    static func dummy(
        duration: String = "0.123s",
        vote: PollVoteResponseData = .dummy()
    ) -> PollVoteResponse {
        PollVoteResponse(
            duration: duration,
            vote: vote
        )
    }
}
