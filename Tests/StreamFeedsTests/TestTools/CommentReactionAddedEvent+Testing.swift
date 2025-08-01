//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension CommentReactionAddedEvent {
    static func dummy(
        comment: CommentResponse = .dummy(),
        reaction: FeedsReactionResponse = .dummy(),
        fid: String = "user:test",
        createdAt: Date = Date(),
        custom: [String: RawJSON] = [:],
        user: UserResponseCommonFields? = nil
    ) -> CommentReactionAddedEvent {
        CommentReactionAddedEvent(
            comment: comment,
            createdAt: createdAt,
            custom: custom,
            fid: fid,
            reaction: reaction,
            user: user
        )
    }
}
