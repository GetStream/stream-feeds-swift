//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class AddCommentsBatchRequest: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var comments: [AddCommentRequest]

    public init(comments: [AddCommentRequest]) {
        self.comments = comments
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case comments
    }

    public static func == (lhs: AddCommentsBatchRequest, rhs: AddCommentsBatchRequest) -> Bool {
        lhs.comments == rhs.comments
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(comments)
    }
}
