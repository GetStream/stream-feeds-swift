//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import Testing

@MainActor func waitUntil(timeout: TimeInterval = 2, _ condition: @MainActor () -> Bool) async throws {
    let deadline = Date().addingTimeInterval(timeout)
    while !condition() {
        guard Date() < deadline else {
            Issue.record("Timed out waiting for the condition")
            return
        }
        try await Task.sleep(nanoseconds: 10_000_000)
    }
}
