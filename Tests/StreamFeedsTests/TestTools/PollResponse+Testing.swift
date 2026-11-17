//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension PollResponse {
    static func dummy(
        poll: PollResponseData = .dummy()
    ) -> PollResponse {
        PollResponse(
            poll: poll
        )
    }
}
