//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class DeleteCommentResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var activity: ActivityResponse
    public var comment: CommentResponse
    public var duration: String

    public init(activity: ActivityResponse, comment: CommentResponse, duration: String) {
        self.activity = activity
        self.comment = comment
        self.duration = duration
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case activity
        case comment
        case duration
    }

    public static func == (lhs: DeleteCommentResponse, rhs: DeleteCommentResponse) -> Bool {
        lhs.activity == rhs.activity &&
            lhs.comment == rhs.comment &&
            lhs.duration == rhs.duration
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(activity)
        hasher.combine(comment)
        hasher.combine(duration)
    }
}
