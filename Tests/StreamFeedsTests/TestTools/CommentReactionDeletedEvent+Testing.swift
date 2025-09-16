//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension CommentReactionDeletedEvent {
    static func dummy(
        comment: CommentResponse = .dummy(),
        createdAt: Date = Date(),
        custom: [String: RawJSON] = [:],
        fid: String = "user:test",
        reaction: FeedsReactionResponse = .dummy()
    ) -> CommentReactionDeletedEvent {
        CommentReactionDeletedEvent(
            comment: comment,
            createdAt: createdAt,
            custom: custom,
            fid: fid,
            reaction: reaction
        )
    }
}
