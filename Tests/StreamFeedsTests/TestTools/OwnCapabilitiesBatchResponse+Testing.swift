//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension OwnCapabilitiesBatchResponse {
    static func dummy(
        capabilities: [String: [FeedOwnCapability]]
    ) -> OwnCapabilitiesBatchResponse {
        OwnCapabilitiesBatchResponse(
            capabilities: capabilities,
            duration: "1.23ms"
        )
    }
}
