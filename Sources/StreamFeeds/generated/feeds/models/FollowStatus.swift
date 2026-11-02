//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Status of a follow request.
public final class FollowStatus: RawRepresentable, Decodable, Hashable, Sendable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public static let accepted = FollowStatus(rawValue: "accepted")
    public static let pending = FollowStatus(rawValue: "pending")
    public static let rejected = FollowStatus(rawValue: "rejected")
}
