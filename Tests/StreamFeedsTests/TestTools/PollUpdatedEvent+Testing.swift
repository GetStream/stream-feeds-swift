//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension PollUpdatedFeedEvent {
    static func dummy(
        poll: PollResponseData = .dummy(),
        fid: String
    ) -> PollUpdatedFeedEvent {
        PollUpdatedFeedEvent(
            createdAt: Date.fixed(),
            custom: [:],
            feedVisibility: nil,
            fid: fid,
            poll: poll,
            receivedAt: Date.fixed()
        )
    }
}
