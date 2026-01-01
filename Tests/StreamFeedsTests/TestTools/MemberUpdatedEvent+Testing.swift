//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension FeedMemberUpdatedEvent {
    static func dummy(
        member: FeedMemberResponse,
        fid: String
    ) -> FeedMemberUpdatedEvent {
        FeedMemberUpdatedEvent(
            createdAt: Date.fixed(),
            custom: [:],
            feedVisibility: nil,
            fid: fid,
            member: member,
            receivedAt: Date.fixed()
        )
    }
}
