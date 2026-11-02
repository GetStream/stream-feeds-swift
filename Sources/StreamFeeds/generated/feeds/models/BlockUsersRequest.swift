//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class BlockUsersRequest: @unchecked Sendable, Codable, JSONEncodable {
    /// User id to block
    public var blockedUserId: String

    public init(blockedUserId: String) {
        self.blockedUserId = blockedUserId
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case blockedUserId = "blocked_user_id"
    }
}

extension BlockUsersRequest: Hashable {
    public static func == (lhs: BlockUsersRequest, rhs: BlockUsersRequest) -> Bool {
        lhs.blockedUserId == rhs.blockedUserId
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(blockedUserId)
    }
}
