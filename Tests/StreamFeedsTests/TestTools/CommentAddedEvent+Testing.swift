//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension CommentAddedEvent {
    static func dummy(
        comment: CommentResponse = .dummy(),
        createdAt: Date = Date(),
        custom: [String: RawJSON] = [:],
        fid: String = "user:test",
        user: UserResponseCommonFields? = nil
    ) -> CommentAddedEvent {
        CommentAddedEvent(
            activity: .dummy(),
            comment: comment,
            createdAt: createdAt,
            custom: custom,
            fid: fid,
            user: user
        )
    }
}
