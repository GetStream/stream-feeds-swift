//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension CommentUpdatedEvent {
    static func dummy(
        comment: CommentResponse = .dummy(),
        createdAt: Date = Date(),
        custom: [String: RawJSON] = [:],
        fid: String = "user:test",
        user: UserResponseCommonFields? = nil
    ) -> CommentUpdatedEvent {
        CommentUpdatedEvent(
            comment: comment,
            createdAt: createdAt,
            custom: custom,
            fid: fid,
            user: user
        )
    }
}
