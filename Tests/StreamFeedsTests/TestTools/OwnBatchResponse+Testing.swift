//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension OwnBatchResponse {
    static func dummy(
        capabilities: [String: [FeedOwnCapability]]
    ) -> OwnBatchResponse {
        OwnBatchResponse(
            data: capabilities.mapValues { FeedOwnData(ownCapabilities: $0) },
            duration: "1.23ms"
        )
    }
}
