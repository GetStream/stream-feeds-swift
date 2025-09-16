//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension PollVoteRemovedFeedEvent {
    static func dummy(
        createdAt: Date = .fixed(),
        custom: [String: RawJSON] = [:],
        feedVisibility: String? = nil,
        fid: String = "user:test",
        poll: PollResponseData = .dummy(),
        pollVote: PollVoteResponseData = .dummy(),
        receivedAt: Date? = nil
    ) -> PollVoteRemovedFeedEvent {
        PollVoteRemovedFeedEvent(
            createdAt: createdAt,
            custom: custom,
            feedVisibility: feedVisibility,
            fid: fid,
            poll: poll,
            pollVote: pollVote,
            receivedAt: receivedAt
        )
    }
}
