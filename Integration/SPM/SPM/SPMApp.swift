//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import StreamFeeds
import SwiftUI

@main
struct SPMApp: App {
    @State var feedsClient: FeedsClient = {
        LogConfig.level = .debug
        return FeedsClient(
            apiKey: APIKey("key"),
            user: .anonymous,
            token: "token"
        )
    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
