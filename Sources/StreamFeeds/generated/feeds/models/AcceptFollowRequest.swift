//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class AcceptFollowRequest: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var followerRole: String?
    public var source: String
    public var target: String

    public init(followerRole: String? = nil, source: String, target: String) {
        self.followerRole = followerRole
        self.source = source
        self.target = target
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case followerRole = "follower_role"
        case source
        case target
    }

    public static func == (lhs: AcceptFollowRequest, rhs: AcceptFollowRequest) -> Bool {
        lhs.followerRole == rhs.followerRole &&
            lhs.source == rhs.source &&
            lhs.target == rhs.target
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(followerRole)
        hasher.combine(source)
        hasher.combine(target)
    }
}
