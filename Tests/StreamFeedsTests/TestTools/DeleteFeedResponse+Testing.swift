//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension DeleteFeedResponse {
    static func dummy(
        taskId: String = "delete-task-123"
    ) -> DeleteFeedResponse {
        DeleteFeedResponse(
            taskId: taskId
        )
    }
}
