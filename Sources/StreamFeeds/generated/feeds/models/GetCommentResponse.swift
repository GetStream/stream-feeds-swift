//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class GetCommentResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var comment: CommentResponse
    public var duration: String

    public init(comment: CommentResponse, duration: String) {
        self.comment = comment
        self.duration = duration
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case comment
        case duration
    }

    public static func == (lhs: GetCommentResponse, rhs: GetCommentResponse) -> Bool {
        lhs.comment == rhs.comment &&
            lhs.duration == rhs.duration
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(comment)
        hasher.combine(duration)
    }
}
