//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UpdateCommentResponse: Sendable, Decodable {
    public let comment: CommentResponse

    public init(comment: CommentResponse) {
        self.comment = comment
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.comment = try container.decode(CommentResponse.self, forKey: .comment)
    }
}

extension UpdateCommentResponse: Hashable {
    public static func == (lhs: UpdateCommentResponse, rhs: UpdateCommentResponse) -> Bool {
        lhs.comment == rhs.comment
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(comment)
    }
}
