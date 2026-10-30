//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class AddCommentsBatchResponse: Sendable, Decodable {
    /// List of comments added
    public let comments: [CommentResponse]
    public let duration: String

    public init(comments: [CommentResponse], duration: String) {
        self.comments = comments
        self.duration = duration
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.comments = try container.decode([CommentResponse].self, forKey: .comments)
        self.duration = try container.decode(String.self, forKey: .duration)
    }
}

extension AddCommentsBatchResponse: Hashable {
    public static func == (lhs: AddCommentsBatchResponse, rhs: AddCommentsBatchResponse) -> Bool {
        lhs.comments == rhs.comments &&
            lhs.duration == rhs.duration
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(comments)
        hasher.combine(duration)
    }
}
