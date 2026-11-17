//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class DeleteCommentResponse: Sendable, Decodable {
    public let activity: ActivityResponse
    public let comment: CommentResponse

    public init(activity: ActivityResponse, comment: CommentResponse) {
        self.activity = activity
        self.comment = comment
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.activity = try container.decode(ActivityResponse.self, forKey: .activity)
        self.comment = try container.decode(CommentResponse.self, forKey: .comment)
    }
}

extension DeleteCommentResponse: Hashable {
    public static func == (lhs: DeleteCommentResponse, rhs: DeleteCommentResponse) -> Bool {
        lhs.activity == rhs.activity &&
            lhs.comment == rhs.comment
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(activity)
        hasher.combine(comment)
    }
}
