//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public struct FeedData: Identifiable, Equatable, Sendable {
    public let createdAt: Date
    public let createdBy: UserData
    public let custom: [String: RawJSON]?
    public let deletedAt: Date?
    public let description: String
    public let feed: FeedId
    public let filterTags: [String]?
    public let followerCount: Int
    public let followingCount: Int
    public let groupId: String
    public let id: String
    public let memberCount: Int
    public let name: String
    public private(set) var ownCapabilities: Set<FeedOwnCapability>?
    public private(set) var ownFollows: [FollowData]?
    public private(set) var ownMembership: FeedMemberData?
    public let pinCount: Int
    public let updatedAt: Date
    public let visibility: String?
}

// MARK: - Mutating the Data

extension FeedData {
    mutating func merge(with incomingData: FeedData) {
        let ownCapabilities = ownCapabilities
        let ownFollows = ownFollows
        let ownMembership = ownMembership
        self = incomingData
        self.ownCapabilities = incomingData.ownCapabilities ?? ownCapabilities
        self.ownFollows = incomingData.ownFollows ?? ownFollows
        self.ownMembership = incomingData.ownMembership ?? ownMembership
    }
    
    mutating func setOwnCapabilities(_ capabilities: Set<FeedOwnCapability>) {
        self.ownCapabilities = capabilities
    }
    
    mutating func mergeFeedOwnCapabilities(from capabilitiesMap: [FeedId: Set<FeedOwnCapability>]) {
        guard let capabilities = capabilitiesMap[feed] else { return }
        setOwnCapabilities(capabilities)
    }
    
    func withFeedOwnCapabilities(from capabilitiesMap: [FeedId: Set<FeedOwnCapability>]) -> FeedData {
        var updated = self
        updated.mergeFeedOwnCapabilities(from: capabilitiesMap)
        return updated
    }
}

// MARK: - Model Conversions

extension FeedResponse {
    func toModel() -> FeedData {
        FeedData(
            createdAt: createdAt,
            createdBy: createdBy.toModel(),
            custom: custom,
            deletedAt: deletedAt,
            description: description,
            feed: FeedId(rawValue: feed),
            filterTags: filterTags,
            followerCount: followerCount,
            followingCount: followingCount,
            groupId: groupId,
            id: id,
            memberCount: memberCount,
            name: name,
            ownCapabilities: ownCapabilities.map(Set.init),
            ownFollows: ownFollows?.map { $0.toModel() },
            ownMembership: ownMembership?.toModel(),
            pinCount: pinCount,
            updatedAt: updatedAt,
            visibility: visibility
        )
    }
}
