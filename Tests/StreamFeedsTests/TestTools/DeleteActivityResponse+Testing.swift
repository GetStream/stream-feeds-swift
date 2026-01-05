//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension DeleteActivityResponse {
    static func dummy(
        duration: String = "1.23ms"
    ) -> DeleteActivityResponse {
        DeleteActivityResponse(
            duration: duration
        )
    }
}
