//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import StreamCore
import StreamFeeds

@MainActor struct Snippets_06_08_URLPreviews {
    var client: FeedsClient!
    var feed: Feed!
    var activityId: String!

    func addingActivityWithURL() async throws {
        let activity = try await feed.addActivity(
            request: .init(
                text: "Check this out: https://example.com/article",
                type: "post"
            )
        )
        // Enrichment is enabled by default; activity.attachments may include OG preview when ready

        suppressUnusedWarning(activity)
    }

    func addingCommentWithURL() async throws {
        let comment = try await feed.addComment(
            request: .init(
                comment: "See also: https://example.com/related",
                objectId: activityId,
                objectType: "activity"
                // skipEnrichUrl: true to disable
            )
        )

        suppressUnusedWarning(comment)
    }

    func skippingEnrichment() async throws {
        // Activity
        let activity = try await feed.addActivity(
            request: .init(
                skipEnrichUrl: true,
                text: "https://example.com/page",
                type: "post"
            )
        )
        // Comment
        let comment = try await feed.addComment(
            request: .init(
                comment: "https://example.com/page",
                objectId: activityId,
                objectType: "activity",
                skipEnrichUrl: true
            )
        )

        suppressUnusedWarning(activity, comment)
    }

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
