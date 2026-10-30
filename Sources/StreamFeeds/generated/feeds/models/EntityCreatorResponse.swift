//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class EntityCreatorResponse: Sendable, Decodable {
    public let user: UserResponse
    /// Number of minor actions performed on the user
    public let banCount: Int
    /// Number of major actions performed on the user
    public let deletedContentCount: Int
    /// Number of flag actions performed on the user
    public let flaggedCount: Int

    public init(user: UserResponse, banCount: Int, deletedContentCount: Int, flaggedCount: Int) {
        self.user = user
        self.banCount = banCount
        self.deletedContentCount = deletedContentCount
        self.flaggedCount = flaggedCount
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.user = try UserResponse(from: decoder)
        self.banCount = try container.decode(Int.self, forKey: .banCount)
        self.deletedContentCount = try container.decode(Int.self, forKey: .deletedContentCount)
        self.flaggedCount = try container.decode(Int.self, forKey: .flaggedCount)
    }
}

extension EntityCreatorResponse: Hashable {
    public static func == (lhs: EntityCreatorResponse, rhs: EntityCreatorResponse) -> Bool {
        lhs.user == rhs.user &&
            lhs.banCount == rhs.banCount &&
            lhs.deletedContentCount == rhs.deletedContentCount &&
            lhs.flaggedCount == rhs.flaggedCount
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(user)
        hasher.combine(banCount)
        hasher.combine(deletedContentCount)
        hasher.combine(flaggedCount)
    }
}
