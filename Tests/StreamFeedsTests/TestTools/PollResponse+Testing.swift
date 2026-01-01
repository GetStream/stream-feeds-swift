//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension PollResponse {
    static func dummy(
        duration: String = "0.123s",
        poll: PollResponseData = .dummy()
    ) -> PollResponse {
        PollResponse(
            duration: duration,
            poll: poll
        )
    }
}
