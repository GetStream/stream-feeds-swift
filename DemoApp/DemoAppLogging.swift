//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamFeeds
import StreamFeedsLogsUI

@MainActor
enum DemoAppLogging {
    static func setUp() {
        LogConfig.level = .debug
        LogConfig.formatters = [
            PrefixLogFormatter(prefixes: [.info: "ℹ️", .debug: "🛠", .warning: "⚠️", .error: "🚨"])
        ]

        LogViewer.install()
        LogViewer.defaultFilter = LogFilter(
            subsystems: Set([LogSubsystem.webSocket, .httpRequests].map(\.description))
        )
        LogViewer.presentsOnShake = true
    }
}
