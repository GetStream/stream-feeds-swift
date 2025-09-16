//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension PollOptionResponse {
    static func dummy(
        duration: String = "0.123s",
        pollOption: PollOptionResponseData = .dummy()
    ) -> PollOptionResponse {
        PollOptionResponse(
            duration: duration,
            pollOption: pollOption
        )
    }
}
