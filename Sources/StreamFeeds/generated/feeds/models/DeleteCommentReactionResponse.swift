//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class DeleteCommentReactionResponse: Sendable, Decodable {
    public let comment: CommentResponse
    public let reaction: FeedsReactionResponse

    public init(comment: CommentResponse, reaction: FeedsReactionResponse) {
        self.comment = comment
        self.reaction = reaction
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.comment = try container.decode(CommentResponse.self, forKey: .comment)
        self.reaction = try container.decode(FeedsReactionResponse.self, forKey: .reaction)
    }
}

extension DeleteCommentReactionResponse: Hashable {
    public static func == (lhs: DeleteCommentReactionResponse, rhs: DeleteCommentReactionResponse) -> Bool {
        lhs.comment == rhs.comment &&
            lhs.reaction == rhs.reaction
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(comment)
        hasher.combine(reaction)
    }
}
