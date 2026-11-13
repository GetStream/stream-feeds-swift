//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class GetBlockedUsersResponse: Sendable, Decodable {
    /// Array of blocked user object
    public let blocks: [BlockedUserResponse]

    public init(blocks: [BlockedUserResponse]) {
        self.blocks = blocks
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.blocks = try container.decode([BlockedUserResponse].self, forKey: .blocks)
    }
}

extension GetBlockedUsersResponse: Hashable {
    public static func == (lhs: GetBlockedUsersResponse, rhs: GetBlockedUsersResponse) -> Bool {
        lhs.blocks == rhs.blocks
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(blocks)
    }
}
