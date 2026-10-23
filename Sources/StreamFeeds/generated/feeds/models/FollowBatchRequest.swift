//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class FollowBatchRequest: @unchecked Sendable, Codable, JSONEncodable {
    /// List of follow relationships to create
    public var follows: [FollowRequest]

    public init(follows: [FollowRequest]) {
        self.follows = follows
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case follows
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
