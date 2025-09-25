//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension PollDeletedFeedEvent {
    static func dummy(
        pollId: String,
        fid: String
    ) -> PollDeletedFeedEvent {
        PollDeletedFeedEvent(
            createdAt: Date.fixed(),
            custom: [:],
            feedVisibility: nil,
            fid: fid,
            poll: .dummy(id: pollId),
            receivedAt: Date.fixed()
        )
    }
}
