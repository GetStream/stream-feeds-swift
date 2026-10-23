//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class FollowBatchResponse: Sendable, Codable, JSONEncodable {
    /// List of newly created follow relationships
    public let created: [FollowResponse]
    public let duration: String
    /// List of current follow relationships
    public let follows: [FollowResponse]

    public init(created: [FollowResponse], duration: String, follows: [FollowResponse]) {
        self.created = created
        self.duration = duration
        self.follows = follows
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.created = try container.decode([FollowResponse].self, forKey: .created)
        self.duration = try container.decode(String.self, forKey: .duration)
        self.follows = try container.decode([FollowResponse].self, forKey: .follows)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(created, forKey: .created)
        try container.encode(duration, forKey: .duration)
        try container.encode(follows, forKey: .follows)
    }
}

extension FollowBatchResponse: Hashable {
    public static func == (lhs: FollowBatchResponse, rhs: FollowBatchResponse) -> Bool {
        lhs.created == rhs.created &&
            lhs.duration == rhs.duration &&
            lhs.follows == rhs.follows
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(created)
        hasher.combine(duration)
        hasher.combine(follows)
    }
}
