//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension User {
    static func dummy(id: String = "test-user-id") -> Self {
        User(
            id: id,
            name: "Test User",
            imageURL: nil,
            role: "admin",
            type: .regular,
            customData: [:]
        )
    }
}
