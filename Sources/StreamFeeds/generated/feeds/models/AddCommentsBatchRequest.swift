//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class AddCommentsBatchRequest: Sendable, Codable, JSONEncodable {
    /// List of comments to add
    public let comments: [AddCommentRequest]

    public init(comments: [AddCommentRequest]) {
        self.comments = comments
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.comments = try container.decode([AddCommentRequest].self, forKey: .comments)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(comments, forKey: .comments)
    }
}

extension AddCommentsBatchRequest: Hashable {
    public static func == (lhs: AddCommentsBatchRequest, rhs: AddCommentsBatchRequest) -> Bool {
        lhs.comments == rhs.comments
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(comments)
    }
}
