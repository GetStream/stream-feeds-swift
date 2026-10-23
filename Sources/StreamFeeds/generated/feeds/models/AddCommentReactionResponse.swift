//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class AddCommentReactionResponse: @unchecked Sendable, Codable, JSONEncodable {
    public var comment: CommentResponse
    /// Duration of the request
    public var duration: String
    public var reaction: FeedsReactionResponse

    public init(comment: CommentResponse, duration: String, reaction: FeedsReactionResponse) {
        self.comment = comment
        self.duration = duration
        self.reaction = reaction
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case comment
        case duration
        case reaction
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.comment = try container.decode(CommentResponse.self, forKey: .comment)
        self.duration = try container.decode(String.self, forKey: .duration)
        self.reaction = try container.decode(FeedsReactionResponse.self, forKey: .reaction)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(comment, forKey: .comment)
        try container.encode(duration, forKey: .duration)
        try container.encode(reaction, forKey: .reaction)
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
