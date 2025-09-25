//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension FeedMemberRemovedEvent {
    static func dummy(
        memberId: String,
        fid: String
    ) -> FeedMemberRemovedEvent {
        FeedMemberRemovedEvent(
            createdAt: Date.fixed(),
            custom: [:],
            feedVisibility: nil,
            fid: fid,
            memberId: memberId,
            receivedAt: Date.fixed()
        )
    }
}
