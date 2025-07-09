//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class AddCommentsBatchResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var comments: [CommentResponse]
    public var duration: String

    public init(comments: [CommentResponse], duration: String) {
        self.comments = comments
        self.duration = duration
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case comments
        case duration
    }

    public static func == (lhs: AddCommentsBatchResponse, rhs: AddCommentsBatchResponse) -> Bool {
        lhs.comments == rhs.comments &&
            lhs.duration == rhs.duration
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(comments)
        hasher.combine(duration)
    }
}
