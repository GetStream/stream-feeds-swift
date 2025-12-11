//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension DeleteActivitiesResponse {
    private static let defaultDuration = "1.23ms"
    
    static func dummy(
        deletedIds: [String] = [],
        duration: String = defaultDuration
    ) -> DeleteActivitiesResponse {
        DeleteActivitiesResponse(
            deletedIds: deletedIds,
            duration: duration
        )
    }
}
