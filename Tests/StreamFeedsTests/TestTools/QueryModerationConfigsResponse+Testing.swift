//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension QueryModerationConfigsResponse {
    static func dummy(
        configs: [ConfigResponse],
        duration: String = "0.123s",
        next: String? = nil,
        prev: String? = nil
    ) -> QueryModerationConfigsResponse {
        QueryModerationConfigsResponse(
            configs: configs,
            duration: duration,
            next: next,
            prev: prev
        )
    }
}
