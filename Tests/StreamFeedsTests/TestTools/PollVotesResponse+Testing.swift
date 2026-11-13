//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension PollVotesResponse {
    static func dummy(
        prev: String? = nil,
        next: String? = nil,
        votes: [PollVoteResponseData]
    ) -> PollVotesResponse {
        PollVotesResponse(
            next: next,
            prev: prev,
            votes: votes
        )
    }
}
