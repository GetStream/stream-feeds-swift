//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class BlockUsersRequest: Sendable, Codable, JSONEncodable {
    /// User id to block
    public let blockedUserId: String

    public init(blockedUserId: String) {
        self.blockedUserId = blockedUserId
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.blockedUserId = try container.decode(String.self, forKey: .blockedUserId)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(blockedUserId, forKey: .blockedUserId)
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
