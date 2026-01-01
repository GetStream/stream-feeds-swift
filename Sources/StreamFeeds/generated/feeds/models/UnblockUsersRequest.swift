//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UnblockUsersRequest: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var blockedUserId: String

    public init(blockedUserId: String) {
        self.blockedUserId = blockedUserId
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case blockedUserId = "blocked_user_id"
    }

    public static func == (lhs: UnblockUsersRequest, rhs: UnblockUsersRequest) -> Bool {
        lhs.blockedUserId == rhs.blockedUserId
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(blockedUserId)
    }
}
