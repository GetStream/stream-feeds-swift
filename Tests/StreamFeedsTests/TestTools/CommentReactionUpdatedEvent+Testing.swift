//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension CommentReactionUpdatedEvent {
    static func dummy(
        comment: CommentResponse,
        fid: String = "test-feed-id",
        reaction: FeedsReactionResponse = FeedsReactionResponse.dummy(),
        user: UserResponseCommonFields? = UserResponseCommonFields.dummy()
    ) -> CommentReactionUpdatedEvent {
        CommentReactionUpdatedEvent(
            activity: ActivityResponse.dummy(id: comment.objectId),
            comment: comment,
            createdAt: Date.fixed(),
            custom: [:],
            feedVisibility: nil,
            fid: fid,
            reaction: reaction,
            receivedAt: Date.fixed(),
            user: user
        )
    }
}
