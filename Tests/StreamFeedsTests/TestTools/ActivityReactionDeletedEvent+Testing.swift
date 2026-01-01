//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension ActivityReactionDeletedEvent {
    static func dummy(
        activity: ActivityResponse = .dummy(),
        fid: String,
        reaction: FeedsReactionResponse = .dummy(),
        user: UserResponseCommonFields? = UserResponseCommonFields.dummy()
    ) -> ActivityReactionDeletedEvent {
        ActivityReactionDeletedEvent(
            activity: activity,
            createdAt: Date.fixed(),
            custom: [:],
            feedVisibility: nil,
            fid: fid,
            reaction: reaction,
            receivedAt: Date.fixed(),
            user: user
        )
    }
}
