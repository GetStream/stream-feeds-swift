//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension ActivityReactionUpdatedEvent {
    static func dummy(
        activity: ActivityResponse = .dummy(),
        fid: String,
        reaction: FeedsReactionResponse = .dummy(),
        user: UserResponseCommonFields? = UserResponseCommonFields.dummy()
    ) -> ActivityReactionUpdatedEvent {
        ActivityReactionUpdatedEvent(
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
