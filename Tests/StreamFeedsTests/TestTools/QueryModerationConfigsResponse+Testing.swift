//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension QueryModerationConfigsResponse {
    static func dummy(
        configs: [ConfigResponse],
        next: String? = nil,
        prev: String? = nil
    ) -> QueryModerationConfigsResponse {
        QueryModerationConfigsResponse(
            configs: configs,
            next: next,
            prev: prev
        )
    }
}
