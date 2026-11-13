//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension DeleteActivitiesResponse {
    static func dummy(
        deletedIds: [String] = []
    ) -> DeleteActivitiesResponse {
        DeleteActivitiesResponse(
            deletedIds: deletedIds
        )
    }
}
