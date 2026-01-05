//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension FeedsClient {
    static func mock(apiTransport: APITransportMock) -> FeedsClient {
        FeedsClient(
            apiKey: APIKey("UnitTests"),
            user: User.dummy(id: "current-user-id"),
            token: "UnitTestingToken",
            feedsConfig: .default,
            apiTransport: apiTransport
        )
    }
}
