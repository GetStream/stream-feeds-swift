//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Membership status of a feed member.
public final class FeedMemberStatus: RawRepresentable, Decodable, Hashable, Sendable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public static let member = FeedMemberStatus(rawValue: "member")
    public static let pending = FeedMemberStatus(rawValue: "pending")
    public static let rejected = FeedMemberStatus(rawValue: "rejected")
}
