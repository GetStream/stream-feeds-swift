//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Moderation status of a comment.
public enum CommentStatus: String, Sendable, Codable, CaseIterable {
    case active
    case deleted
    case hidden
    case removed
    case shadowBlocked = "shadow_blocked"
    case unknown = "_unknown"

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let decodedValue = try? container.decode(String.self),
           let value = CommentStatus(rawValue: decodedValue) {
            self = value
        } else {
            self = .unknown
        }
    }
}
