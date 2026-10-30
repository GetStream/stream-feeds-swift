//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class SingleFollowResponse: Sendable, Decodable {
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

extension SingleFollowResponse: Hashable {
    public static func == (lhs: SingleFollowResponse, rhs: SingleFollowResponse) -> Bool {
        lhs.duration == rhs.duration &&
            lhs.follow == rhs.follow
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(duration)
        hasher.combine(follow)
    }
}
