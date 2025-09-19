//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension NotificationStatusResponse {
    static func dummy(
        lastReadAt: Date? = .fixed(),
        lastSeenAt: Date? = .fixed(),
        readActivities: [String]? = ["activity-1"],
        seenActivities: [String]? = ["activity-1"],
        unread: Int = 5,
        unseen: Int = 3
    ) -> NotificationStatusResponse {
        NotificationStatusResponse(
            lastReadAt: lastReadAt,
            lastSeenAt: lastSeenAt,
            readActivities: readActivities,
            seenActivities: seenActivities,
            unread: unread,
            unseen: unseen
        )
    }
}
