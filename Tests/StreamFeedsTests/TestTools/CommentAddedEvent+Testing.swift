//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension CommentAddedEvent {
    static func dummy(
        activity: ActivityResponse,
        comment: CommentResponse,
        fid: String,
        user: UserResponseCommonFields? = UserResponseCommonFields.dummy()
    ) -> CommentAddedEvent {
        CommentAddedEvent(
            activity: activity,
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
