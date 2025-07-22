//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension FeedsClient {
    static func mock(apiTransport: APITransportMock) -> FeedsClient {
        FeedsClient(
            apiKey: APIKey("UnitTests"),
            user: User.dummy(),
            token: "UnitTestingToken",
            feedsConfig: .default,
            apiTransport: apiTransport
        )
    }
}
