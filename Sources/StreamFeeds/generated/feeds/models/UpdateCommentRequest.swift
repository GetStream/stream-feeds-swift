//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UpdateCommentRequest: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var comment: String?
    public var custom: [String: RawJSON]?
    public var skipPush: Bool?

    public init(comment: String? = nil, custom: [String: RawJSON]? = nil, skipPush: Bool? = nil) {
        self.comment = comment
        self.custom = custom
        self.skipPush = skipPush
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case comment
        case custom
        case skipPush = "skip_push"
    }

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
