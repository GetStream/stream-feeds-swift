//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension FeedsClient {
    static func mock(apiTransport: APITransportMock, feedsConfig: FeedsConfig = .default) -> FeedsClient {
        FeedsClient(
            apiKey: APIKey("UnitTests"),
            user: User.dummy(id: "current-user-id"),
            token: "UnitTestingToken",
            feedsConfig: feedsConfig,
            apiTransport: apiTransport
        )
    }

    func simulateReconnection() {
        connectionSubject.withLock { subject in
            subject.send(.connecting)
            subject.send(.connected)
            subject.send(.disconnected(error: TestError()))
            subject.send(.connecting)
            subject.send(.connected)
        }
    }
}
