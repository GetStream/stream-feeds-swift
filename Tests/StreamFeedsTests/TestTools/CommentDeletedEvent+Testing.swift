//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension CommentDeletedEvent {
    static func dummy(
        comment: CommentResponse = .dummy(),
        fid: String = "user:test",
        createdAt: Date = Date(),
        custom: [String: RawJSON] = [:],
        user: UserResponseCommonFields? = nil
    ) -> CommentDeletedEvent {
        CommentDeletedEvent(
            comment: comment,
            createdAt: createdAt,
            custom: custom,
            fid: fid,
            user: user
        )
    }
}
