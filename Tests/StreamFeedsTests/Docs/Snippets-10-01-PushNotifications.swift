//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import StreamCore
import StreamFeeds

@MainActor struct Snippets_10_01_PushNotifications {
    var client: FeedsClient!

    func listingDevices() async throws {
        let devices = try await client.queryDevices()

        suppressUnusedWarning(devices)
    }
}
