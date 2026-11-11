//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Basic response information
public final class TranslateCommentResponse: Sendable, Decodable {
    public let comment: CommentResponse
    /// Duration of the request in milliseconds
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
}

extension TranslateCommentResponse: Hashable {
    public static func == (lhs: TranslateCommentResponse, rhs: TranslateCommentResponse) -> Bool {
        lhs.comment == rhs.comment &&
            lhs.duration == rhs.duration
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(comment)
        hasher.combine(duration)
    }
}
