//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UpdateCommentResponse: Sendable, Codable, JSONEncodable {
    public let comment: CommentResponse
    public let duration: String

    public init(comment: CommentResponse, duration: String) {
        self.comment = comment
        self.duration = duration
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.comment = try container.decode(CommentResponse.self, forKey: .comment)
        self.duration = try container.decode(String.self, forKey: .duration)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(comment, forKey: .comment)
        try container.encode(duration, forKey: .duration)
    }
}

extension UpdateCommentResponse: Hashable {
    public static func == (lhs: UpdateCommentResponse, rhs: UpdateCommentResponse) -> Bool {
        lhs.comment == rhs.comment &&
            lhs.duration == rhs.duration
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(comment)
        hasher.combine(duration)
    }
}
