//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UpdateCommentRequest: @unchecked Sendable, Codable, JSONEncodable {
    /// Updated text content of the comment
    public var comment: String?
    /// Updated custom data for the comment
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

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.comment = try container.decodeIfPresent(String.self, forKey: .comment)
        self.custom = try container.decodeIfPresent([String: RawJSON].self, forKey: .custom)
        self.skipPush = try container.decodeIfPresent(Bool.self, forKey: .skipPush)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
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
