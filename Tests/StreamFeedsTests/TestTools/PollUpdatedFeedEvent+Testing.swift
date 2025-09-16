//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension PollUpdatedFeedEvent {
    static func dummy(
        createdAt: Date = .fixed(),
        custom: [String: RawJSON] = [:],
        feedVisibility: String? = nil,
        fid: String = "user:test",
        poll: PollResponseData = .dummy(),
        receivedAt: Date? = nil
    ) -> PollUpdatedFeedEvent {
        PollUpdatedFeedEvent(
            createdAt: createdAt,
            custom: custom,
            feedVisibility: feedVisibility,
            fid: fid,
            poll: poll,
            receivedAt: receivedAt
        )
    }
}
