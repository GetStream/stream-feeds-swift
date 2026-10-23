//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class FollowBatchResponse: Sendable, Codable, JSONEncodable {
    public let duration: String
    /// List of current follow relationships
    public let follows: [FollowResponse]

    public init(duration: String, follows: [FollowResponse]) {
        self.duration = duration
        self.follows = follows
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.duration = try container.decode(String.self, forKey: .duration)
        self.follows = try container.decode([FollowResponse].self, forKey: .follows)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(duration, forKey: .duration)
        try container.encode(follows, forKey: .follows)
    }
}

extension FollowBatchResponse: Hashable {
    public static func == (lhs: FollowBatchResponse, rhs: FollowBatchResponse) -> Bool {
        lhs.duration == rhs.duration &&
            lhs.follows == rhs.follows
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(duration)
        hasher.combine(follows)
    }
}
