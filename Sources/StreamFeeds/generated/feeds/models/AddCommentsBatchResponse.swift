//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class AddCommentsBatchResponse: Sendable, Decodable {
    /// List of comments added
    public let comments: [CommentResponse]

    public init(comments: [CommentResponse]) {
        self.comments = comments
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.comments = try container.decode([CommentResponse].self, forKey: .comments)
    }
}

extension AddCommentsBatchResponse: Hashable {
    public static func == (lhs: AddCommentsBatchResponse, rhs: AddCommentsBatchResponse) -> Bool {
        lhs.comments == rhs.comments
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(comments)
    }
}
