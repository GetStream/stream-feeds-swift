//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Moderation status of a comment.
public final class CommentStatus: RawRepresentable, Decodable, Hashable, Sendable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public static let active = CommentStatus(rawValue: "active")
    public static let deleted = CommentStatus(rawValue: "deleted")
    public static let hidden = CommentStatus(rawValue: "hidden")
    public static let removed = CommentStatus(rawValue: "removed")
    public static let shadowBlocked = CommentStatus(rawValue: "shadow_blocked")
}
