//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class FollowBatchRequest: Sendable, Codable, JSONEncodable {
    /// List of follow relationships to create
    public let follows: [FollowRequest]

    public init(follows: [FollowRequest]) {
        self.follows = follows
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.follows = try container.decode([FollowRequest].self, forKey: .follows)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(follows, forKey: .follows)
    }
}

extension FollowBatchRequest: Hashable {
    public static func == (lhs: FollowBatchRequest, rhs: FollowBatchRequest) -> Bool {
        lhs.follows == rhs.follows
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(follows)
    }
}
