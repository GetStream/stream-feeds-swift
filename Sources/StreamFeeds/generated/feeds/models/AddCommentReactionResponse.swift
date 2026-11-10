//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class AddCommentReactionResponse: Sendable, Decodable {
    public let comment: CommentResponse
    /// Duration of the request
    public let duration: String
    public let reaction: FeedsReactionResponse

    public init(comment: CommentResponse, duration: String, reaction: FeedsReactionResponse) {
        self.comment = comment
        self.duration = duration
        self.reaction = reaction
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.comment = try container.decode(CommentResponse.self, forKey: .comment)
        self.duration = try container.decode(String.self, forKey: .duration)
        self.reaction = try container.decode(FeedsReactionResponse.self, forKey: .reaction)
    }
}

extension AddCommentReactionResponse: Hashable {
    public static func == (lhs: AddCommentReactionResponse, rhs: AddCommentReactionResponse) -> Bool {
        lhs.comment == rhs.comment &&
            lhs.duration == rhs.duration &&
            lhs.reaction == rhs.reaction
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(comment)
        hasher.combine(duration)
        hasher.combine(reaction)
    }
}
