//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension PagerResponse {
    static func dummy() -> PagerResponse {
        PagerResponse(
            next: "next-cursor",
            prev: "prev-cursor"
        )
    }
}
