//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension DeleteFeedResponse {
    static func dummy(
        duration: String = "1.23ms",
        taskId: String = "delete-task-123"
    ) -> DeleteFeedResponse {
        DeleteFeedResponse(
            duration: duration,
            taskId: taskId
        )
    }
}
