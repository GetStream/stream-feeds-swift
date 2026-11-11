//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import StreamCore
import StreamFeeds

@MainActor struct Snippets_06_06_UserMentions {
    var client: FeedsClient!
    var feed: Feed!

    func readingMentions() async throws {
        // From activities
        try await feed.getOrCreate()
        for activity in feed.state.activities where !activity.mentionedUsers.isEmpty {
            print("Mentioned: \(activity.mentionedUsers.compactMap(\.name).joined(separator: ", "))")
        }

        // From comments
        let activity = client.activity(for: "activity_123", in: feed.feed)
        try await activity.get()
        for comment in activity.state.comments where !comment.mentionedUsers.isEmpty {
            print("Comment mentioned: \(comment.mentionedUsers.compactMap(\.name).joined(separator: ", "))")
        }
    }
}
