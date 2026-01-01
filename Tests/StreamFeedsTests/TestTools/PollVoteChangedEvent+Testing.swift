//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension PollVoteChangedFeedEvent {
    static func dummy(
        poll: PollResponseData = .dummy(),
        vote: PollVoteResponseData = .dummy(),
        fid: String
    ) -> PollVoteChangedFeedEvent {
        PollVoteChangedFeedEvent(
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
