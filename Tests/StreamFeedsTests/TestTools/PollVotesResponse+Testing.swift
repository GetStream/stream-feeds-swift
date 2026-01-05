//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension PollVotesResponse {
    static func dummy(
        duration: String = "0.123s",
        prev: String? = nil,
        next: String? = nil,
        votes: [PollVoteResponseData]
    ) -> PollVotesResponse {
        PollVotesResponse(
            duration: duration,
            next: next,
            prev: prev,
            votes: votes
        )
    }
}
