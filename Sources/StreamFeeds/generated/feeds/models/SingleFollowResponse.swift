//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class SingleFollowResponse: @unchecked Sendable, Codable, JSONEncodable {
    public var duration: String
    public var follow: FollowResponse

    public init(duration: String, follow: FollowResponse) {
        self.duration = duration
        self.follow = follow
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case duration
        case follow
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
