//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import StreamCore
import StreamFeeds

@MainActor struct Snippets_06_08_URLPreviews {
    var client: FeedsClient!
    var activityId: String!

    func readingPreviews() async throws {
        // From an activity
        let activity = client.activity(
            for: activityId,
            in: FeedId(group: "user", id: "john")
        )
        try await activity.get()
        for attachment in activity.state.activity?.attachments ?? [] {
            // use attachment.title, attachment.imageUrl, etc.
            print(attachment.title ?? "")
        }

        // From a comment
        for comment in activity.state.comments {
            for attachment in comment.attachments ?? [] {
                // use attachment.title, attachment.imageUrl, etc.
                print(attachment.title ?? "")
            }
        }
    }
}
