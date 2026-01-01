//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamFeeds

@MainActor struct Snippets_05_02_Aggregation {
    var client: FeedsClient!
    var notificationFeed: Feed!
    
    func dataFormat() async throws {
        // Mark all activities in the feed as seen
        try await notificationFeed.markActivity(
            request: .init(markAllSeen: true)
        )
        // Mark some activities as read via specific Activity Group Ids
        try await notificationFeed.markActivity(
            request: .init(
                markRead: ["activityGroupIdOne", "activityGroupIdTwo"]
            )
        )
    }
}
