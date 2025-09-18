//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension CommentReactionAddedEvent {
    static func dummy(
        comment: CommentResponse = .dummy(),
        createdAt: Date = Date(),
        custom: [String: RawJSON] = [:],
        fid: String,
        reaction: FeedsReactionResponse = .dummy(),
        user: UserResponseCommonFields? = nil
    ) -> CommentReactionAddedEvent {
        CommentReactionAddedEvent(
            activity: .dummy(),
            comment: comment,
            createdAt: createdAt,
            custom: custom,
            fid: fid,
            reaction: reaction,
            user: user
        )
    }
}
