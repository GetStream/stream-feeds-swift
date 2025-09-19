//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension CommentUpdatedEvent {
    static func dummy(
        comment: CommentResponse = CommentResponse.dummy(),
        fid: String,
        user: UserResponseCommonFields? = UserResponseCommonFields.dummy()
    ) -> CommentUpdatedEvent {
        CommentUpdatedEvent(
            comment: comment,
            createdAt: Date.fixed(),
            custom: [:],
            feedVisibility: nil,
            fid: fid,
            receivedAt: Date.fixed(),
            user: user
        )
    }
}
