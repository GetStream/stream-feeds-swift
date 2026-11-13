//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UnfollowResponse: Sendable, Decodable {
    public let follow: FollowResponse

    public init(follow: FollowResponse) {
        self.follow = follow
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.follow = try container.decode(FollowResponse.self, forKey: .follow)
    }
}

extension UnfollowResponse: Hashable {
    public static func == (lhs: UnfollowResponse, rhs: UnfollowResponse) -> Bool {
        lhs.follow == rhs.follow
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(follow)
    }
}
