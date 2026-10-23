//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class FollowBatchResponse: @unchecked Sendable, Codable, JSONEncodable {
    public var duration: String
    /// List of current follow relationships
    public var follows: [FollowResponse]

    public init(duration: String, follows: [FollowResponse]) {
        self.duration = duration
        self.follows = follows
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case duration
        case follows
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
