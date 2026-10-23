//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UpdateFollowResponse: Sendable, Decodable {
    public let duration: String
    public let follow: FollowResponse

    public init(duration: String, follow: FollowResponse) {
        self.duration = duration
        self.follow = follow
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.duration = try container.decode(String.self, forKey: .duration)
        self.follow = try container.decode(FollowResponse.self, forKey: .follow)
    }
}

extension UpdateFollowResponse: Hashable {
    public static func == (lhs: UpdateFollowResponse, rhs: UpdateFollowResponse) -> Bool {
        lhs.duration == rhs.duration &&
            lhs.follow == rhs.follow
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(duration)
        hasher.combine(follow)
    }
}
