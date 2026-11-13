//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import StreamCore
import StreamFeeds

@MainActor struct Snippets_06_05_Translation {
    var client: FeedsClient!
    var feed: Feed!

    func translateActivity() async throws {
        let activity = try await feed.translateActivity(id: "activity_123", to: "fr")

        print(activity.translatedText(for: "fr") ?? "")
        // "Bonjour, j'aimerais en savoir plus sur votre produit."
    }

    func translateComment() async throws {
        let comment = try await feed.translateComment(commentId: "comment_456", to: "es")

        print(comment.translatedText(for: "es") ?? "")
    }

    func defaultProjection() async throws {
        let feed = client.feed(for: FeedQuery(group: "user", id: "john", language: "es"))
        try await feed.getOrCreate()

        // text is still the original English
        print(feed.state.activities[0].text ?? "")
        // "Hello world"

        // the Spanish translation, when one is stored
        print(feed.state.activities[0].translatedText(for: "es") ?? "")
        // "Hola mundo"
    }
}
