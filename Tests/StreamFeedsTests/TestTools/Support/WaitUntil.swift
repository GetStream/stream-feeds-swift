//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation

struct TimeoutError: Error, CustomStringConvertible {
    let description: String
}

@MainActor func waitUntil(timeout: TimeInterval = 2, _ condition: @MainActor () -> Bool) async throws {
    let deadline = Date().addingTimeInterval(timeout)
    while !condition() {
        guard Date() < deadline else { throw TimeoutError(description: "Timed out waiting for the condition") }
        try await Task.sleep(nanoseconds: 10_000_000)
    }
}
