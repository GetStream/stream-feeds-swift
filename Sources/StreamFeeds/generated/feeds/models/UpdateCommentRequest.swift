//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UpdateCommentRequest: Sendable, Encodable, JSONEncodable {
    /// Updated text content of the comment
    public let comment: String?
    /// Updated custom data for the comment
    public let custom: [String: RawJSON]?
    public let skipPush: Bool?

    public init(comment: String? = nil, custom: [String: RawJSON]? = nil, skipPush: Bool? = nil) {
        self.comment = comment
        self.custom = custom
        self.skipPush = skipPush
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(comment, forKey: .comment)
        try container.encodeIfPresent(custom, forKey: .custom)
        try container.encodeIfPresent(skipPush, forKey: .skipPush)
    }
}

extension UpdateCommentRequest: Hashable {
    public static func == (lhs: UpdateCommentRequest, rhs: UpdateCommentRequest) -> Bool {
        lhs.comment == rhs.comment &&
            lhs.custom == rhs.custom &&
            lhs.skipPush == rhs.skipPush
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(comment)
        hasher.combine(custom)
        hasher.combine(skipPush)
    }
}
