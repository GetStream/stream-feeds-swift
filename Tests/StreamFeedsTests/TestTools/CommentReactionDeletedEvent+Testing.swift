//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension CommentReactionDeletedEvent {
    static func dummy(
        comment: CommentResponse = .dummy(),
        reaction: FeedsReactionResponse = .dummy(),
        fid: String = "user:test",
        createdAt: Date = Date(),
        custom: [String: RawJSON] = [:]
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
