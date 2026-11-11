//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Which follow relationship friend reactions are drawn from.
public final class FriendReactionType: RawRepresentable, Encodable, CustomStringConvertible, Hashable, Sendable {
    public let rawValue: String

    public var description: String { rawValue }

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public static let following = FriendReactionType(rawValue: "following")
    public static let mutual = FriendReactionType(rawValue: "mutual")
}
