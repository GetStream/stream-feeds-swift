//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension PollVoteResponse {
    static func dummy(
        vote: PollVoteResponseData = .dummy()
    ) -> PollVoteResponse {
        PollVoteResponse(
            vote: vote
        )
    }
}
