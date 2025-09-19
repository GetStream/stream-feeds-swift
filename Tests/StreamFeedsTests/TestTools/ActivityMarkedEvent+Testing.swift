//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

// Type alias for ActivityMarkEvent to match test expectations
typealias ActivityMarkedEvent = ActivityMarkEvent

extension ActivityMarkEvent {
    static func dummy(
        markAllRead: Bool? = nil,
        markAllSeen: Bool? = nil,
        markRead: [String]? = nil,
        markSeen: [String]? = nil,
        markWatched: [String]? = nil,
        fid: String,
        user: UserResponseCommonFields? = UserResponseCommonFields.dummy()
    ) -> ActivityMarkEvent {
        ActivityMarkEvent(
            createdAt: Date.fixed(),
            custom: [:],
            feedVisibility: nil,
            fid: fid,
            markAllRead: markAllRead,
            markAllSeen: markAllSeen,
            markRead: markRead,
            markSeen: markSeen,
            markWatched: markWatched,
            receivedAt: Date.fixed(),
            user: user
        )
    }
}
