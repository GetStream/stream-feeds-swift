//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension StreamFeeds.Response {
    static func dummy(
        duration: String = "0.123s"
    ) -> StreamFeeds.Response {
        StreamFeeds.Response(
            duration: duration
        )
    }
}
