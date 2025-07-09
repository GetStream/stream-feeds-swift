//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UpdateCommentRequest: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var comment: String?
    public var custom: [String: RawJSON]?

    public init(comment: String? = nil, custom: [String: RawJSON]? = nil) {
        self.comment = comment
        self.custom = custom
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case comment
        case custom
    }

    public static func == (lhs: UpdateCommentRequest, rhs: UpdateCommentRequest) -> Bool {
        lhs.comment == rhs.comment &&
            lhs.custom == rhs.custom
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(comment)
        hasher.combine(custom)
    }
}
