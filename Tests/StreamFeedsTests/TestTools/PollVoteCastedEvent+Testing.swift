//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension PollVoteCastedFeedEvent {
    static func dummy(
        poll: PollResponseData = .dummy(),
        vote: PollVoteResponseData = .dummy(),
        fid: String
    ) -> PollVoteCastedFeedEvent {
        PollVoteCastedFeedEvent(
            createdAt: Date.fixed(),
            custom: [:],
            feedVisibility: nil,
            fid: fid,
            poll: poll,
            pollVote: vote,
            receivedAt: Date.fixed()
        )
    }
}
