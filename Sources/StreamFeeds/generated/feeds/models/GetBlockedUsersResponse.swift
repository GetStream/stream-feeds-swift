//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class GetBlockedUsersResponse: Sendable, Codable, JSONEncodable {
    /// Array of blocked user object
    public let blocks: [BlockedUserResponse]
    /// Duration of the request in milliseconds
    public let duration: String

    public init(blocks: [BlockedUserResponse], duration: String) {
        self.blocks = blocks
        self.duration = duration
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.blocks = try container.decode([BlockedUserResponse].self, forKey: .blocks)
        self.duration = try container.decode(String.self, forKey: .duration)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(blocks, forKey: .blocks)
        try container.encode(duration, forKey: .duration)
    }
}

extension GetBlockedUsersResponse: Hashable {
    public static func == (lhs: GetBlockedUsersResponse, rhs: GetBlockedUsersResponse) -> Bool {
        lhs.blocks == rhs.blocks &&
            lhs.duration == rhs.duration
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(blocks)
        hasher.combine(duration)
    }
}
