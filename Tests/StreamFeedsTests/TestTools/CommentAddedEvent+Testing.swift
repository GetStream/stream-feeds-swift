//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension CommentAddedEvent {
    static func dummy(
        comment: CommentResponse,
        fid: String,
        user: UserResponseCommonFields? = UserResponseCommonFields.dummy()
    ) -> CommentAddedEvent {
        CommentAddedEvent(
            activity: ActivityResponse.dummy(id: comment.objectId),
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
