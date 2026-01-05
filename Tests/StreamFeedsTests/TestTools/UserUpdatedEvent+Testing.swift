//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension UserUpdatedEvent {
    static func dummy(
        user: UserResponsePrivacyFields = .dummy()
    ) -> UserUpdatedEvent {
        UserUpdatedEvent(
            createdAt: Date.fixed(),
            custom: [:],
            user: user
        )
    }
}
