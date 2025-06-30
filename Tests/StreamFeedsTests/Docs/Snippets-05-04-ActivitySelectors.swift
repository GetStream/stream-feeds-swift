//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation

struct Snippets_05_04_ActivitySelectors {
    func popularActivitySelector() async throws {
        // Note: This is typically configured server-side
        let popularSelector: [String: Any] = [
            "min_popularity": 10,
            "type": "popular"
        ]

        let feedGroupConfig: [String: Any] = [
            "id": "foryou",
            "activity_selectors": [popularSelector]
        ]
        
        suppressUnusedWarning(feedGroupConfig)
    }
}
