//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds
import Testing

struct ModelConversion_Tests {
    @Test func activityMapsCollections() {
        let activity = ActivityResponse.dummy(
            collections: [
                "products:item-1": EnrichedCollectionResponse(id: "item-1", name: "products", status: .ok, userId: "user-1"),
                "products:item-2": EnrichedCollectionResponse(id: "item-2", name: "products", status: .notfound)
            ]
        ).toModel()

        #expect(activity.collections["products:item-1"] == CollectionData(
            createdAt: nil,
            custom: nil,
            id: "item-1",
            name: "products",
            status: .ok,
            updatedAt: nil,
            userId: "user-1"
        ))
        #expect(activity.collections["products:item-2"]?.status == .notfound)
    }
}
