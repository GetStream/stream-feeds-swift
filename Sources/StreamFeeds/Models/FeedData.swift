//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import CoreLocation
import Foundation
import StreamCore

public struct FeedData: Identifiable, Equatable, Sendable {
    /// The number of activities in the feed.
    public let activityCount: Int
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
    /// The geographic location of the feed.
    public let location: CLLocationCoordinate2D?
    public let memberCount: Int
    public let name: String
    public private(set) var ownCapabilities: Set<FeedOwnCapability>?
    public private(set) var ownFollows: [FollowData]?
    /// Follows from the feed owner's feeds to the current user's feeds.
    ///
    /// - Important: Only set when the request asks for own fields: ``EnrichmentOptions/enrichOwnFollowings`` in ``FeedQuery/enrichmentOptions``, or `enrichOwnFields` in ``FeedsQuery``, ``ActivitiesQuery``, ``BookmarksQuery``, ``FeedAddActivityRequest`` or ``Feed/follow(_:activityCopyLimit:createNotificationActivity:custom:enrichOwnFields:pushPreference:skipPush:)``. ``Activity/get()`` includes it by default.
    public private(set) var ownFollowings: [FollowData]?
    public private(set) var ownMembership: FeedMemberData?
    public let pinCount: Int
    public let updatedAt: Date
    public let visibility: FeedVisibility?
}

// MARK: - Mutating the Data

extension FeedData {
    mutating func merge(with incomingData: FeedData) {
        let ownCapabilities = ownCapabilities
        let ownFollows = ownFollows
        let ownFollowings = ownFollowings
        let ownMembership = ownMembership
        self = incomingData
        self.ownCapabilities = incomingData.ownCapabilities ?? ownCapabilities
        self.ownFollows = incomingData.ownFollows ?? ownFollows
        self.ownFollowings = incomingData.ownFollowings ?? ownFollowings
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
            activityCount: activityCount,
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
            location: location.flatMap { CLLocationCoordinate2D(latitude: CLLocationDegrees($0.lat), longitude: CLLocationDegrees($0.lng)) },
            memberCount: memberCount,
            name: name,
            ownCapabilities: ownCapabilities.map(Set.init),
            ownFollows: ownFollows?.map { $0.toModel() },
            ownFollowings: ownFollowings?.map { $0.toModel() },
            ownMembership: ownMembership?.toModel(),
            pinCount: pinCount,
            updatedAt: updatedAt,
            visibility: visibility
        )
    }
}
