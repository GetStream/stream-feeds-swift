//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds
import Testing

struct RequestConversion_Tests {
    @Test func feedAddActivityRequestPassesCollections() {
        let collections = [CollectionRequest(custom: ["title": .string("Item")], id: "item-1", name: "products")]
        let request = FeedAddActivityRequest(
            collectionReferences: ["products:item-2"],
            collections: collections,
            type: "post"
        ).withFeed(FeedId(group: "user", id: "jane"), uploadedAttachments: [])

        #expect(request.collectionRefs == ["products:item-2"])
        #expect(request.collections == collections)
        #expect(request.feeds == ["user:jane"])
    }
}
