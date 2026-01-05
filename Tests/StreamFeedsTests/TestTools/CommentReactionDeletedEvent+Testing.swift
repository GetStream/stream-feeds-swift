//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension CommentReactionDeletedEvent {
    static func dummy(
        comment: CommentResponse,
        createdAt: Date = Date(),
        custom: [String: RawJSON] = [:],
        fid: String,
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
