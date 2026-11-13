//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension PollOptionResponse {
    static func dummy(
        pollOption: PollOptionResponseData = .dummy()
    ) -> PollOptionResponse {
        PollOptionResponse(
            pollOption: pollOption
        )
    }
}
