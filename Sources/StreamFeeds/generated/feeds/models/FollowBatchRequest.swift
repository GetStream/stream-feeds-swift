//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class FollowBatchRequest: Sendable, Encodable, JSONEncodable {
    /// List of follow relationships to create
    public let follows: [FollowRequest]

    public init(follows: [FollowRequest]) {
        self.follows = follows
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
