//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class FeedOwnData: Sendable, Decodable {
    /// Capabilities the current user has for this feed
    public let ownCapabilities: [FeedOwnCapability]?
    /// Follow relationships where the feed owner's feeds are following the current user's feeds (up to 5 total)
    public let ownFollowings: [FollowResponse]?
    /// Follow relationships where the current user's feeds are following this feed
    public let ownFollows: [FollowResponse]?
    public let ownMembership: FeedMemberResponse?

    public init(ownCapabilities: [FeedOwnCapability]? = nil, ownFollowings: [FollowResponse]? = nil, ownFollows: [FollowResponse]? = nil, ownMembership: FeedMemberResponse? = nil) {
        self.ownCapabilities = ownCapabilities
        self.ownFollowings = ownFollowings
        self.ownFollows = ownFollows
        self.ownMembership = ownMembership
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.ownCapabilities = try container.decodeIfPresent([FeedOwnCapability].self, forKey: .ownCapabilities)
        self.ownFollowings = try container.decodeIfPresent([FollowResponse].self, forKey: .ownFollowings)
        self.ownFollows = try container.decodeIfPresent([FollowResponse].self, forKey: .ownFollows)
        self.ownMembership = try container.decodeIfPresent(FeedMemberResponse.self, forKey: .ownMembership)
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
