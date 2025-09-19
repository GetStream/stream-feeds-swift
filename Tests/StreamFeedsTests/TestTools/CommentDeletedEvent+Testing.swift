//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension CommentDeletedEvent {
    static func dummy(
        comment: CommentResponse = .dummy(),
        fid: String,
        user: UserResponseCommonFields? = UserResponseCommonFields.dummy()
    ) -> CommentDeletedEvent {
        CommentDeletedEvent(
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
