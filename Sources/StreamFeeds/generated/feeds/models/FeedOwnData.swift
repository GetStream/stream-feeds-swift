//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class FeedOwnData: @unchecked Sendable, Codable, JSONEncodable {
    /// Capabilities the current user has for this feed
    public var ownCapabilities: [FeedOwnCapability]?
    /// Follow relationships where the feed owner's feeds are following the current user's feeds (up to 5 total)
    public var ownFollowings: [FollowResponse]?
    /// Follow relationships where the current user's feeds are following this feed
    public var ownFollows: [FollowResponse]?
    public var ownMembership: FeedMemberResponse?

    public init(ownCapabilities: [FeedOwnCapability]? = nil, ownFollowings: [FollowResponse]? = nil, ownFollows: [FollowResponse]? = nil, ownMembership: FeedMemberResponse? = nil) {
        self.ownCapabilities = ownCapabilities
        self.ownFollowings = ownFollowings
        self.ownFollows = ownFollows
        self.ownMembership = ownMembership
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case ownCapabilities = "own_capabilities"
        case ownFollowings = "own_followings"
        case ownFollows = "own_follows"
        case ownMembership = "own_membership"
    }
}

extension FeedOwnData: Hashable {
    public static func == (lhs: FeedOwnData, rhs: FeedOwnData) -> Bool {
        lhs.ownCapabilities == rhs.ownCapabilities &&
            lhs.ownFollowings == rhs.ownFollowings &&
            lhs.ownFollows == rhs.ownFollows &&
            lhs.ownMembership == rhs.ownMembership
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(ownCapabilities)
        hasher.combine(ownFollowings)
        hasher.combine(ownFollows)
        hasher.combine(ownMembership)
    }
}
