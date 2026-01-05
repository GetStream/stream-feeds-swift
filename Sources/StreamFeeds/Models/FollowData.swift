//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public struct FollowData: Equatable, Sendable {
    public let createdAt: Date
    public let custom: [String: RawJSON]?
    public let followerRole: String
    public let pushPreference: String
    public let requestAcceptedAt: Date?
    public let requestRejectedAt: Date?
    public private(set) var sourceFeed: FeedData
    public let status: FollowStatus
    public private(set) var targetFeed: FeedData
    public let updatedAt: Date
        
    var isFollower: Bool {
        status == .accepted
    }
    
    var isFollowing: Bool {
        status == .accepted
    }
    
    var isFollowRequest: Bool {
        status == .pending
    }
    
    func isFollower(of feed: FeedId) -> Bool {
        isFollower && targetFeed.feed == feed
    }
    
    func isFollowing(_ feed: FeedId) -> Bool {
        isFollowing && sourceFeed.feed == feed
    }
}

public typealias FollowStatus = FollowResponse.FollowResponseStatus

extension FollowData: Identifiable {
    public var id: String {
        "\(sourceFeed.feed)-\(targetFeed.feed)"
    }
}

// MARK: - Mutating the Data

extension FollowData {
    // MARK: - Current Feed Capabilities
    
    mutating func mergeFeedOwnCapabilities(from capabilitiesMap: [FeedId: Set<FeedOwnCapability>]) {
        if let capabilities = capabilitiesMap[sourceFeed.feed] {
            sourceFeed.setOwnCapabilities(capabilities)
        }
        if let capabilities = capabilitiesMap[targetFeed.feed] {
            targetFeed.setOwnCapabilities(capabilities)
        }
    }
    
    func withFeedOwnCapabilities(from capabilitiesMap: [FeedId: Set<FeedOwnCapability>]) -> FollowData {
        var updated = self
        updated.mergeFeedOwnCapabilities(from: capabilitiesMap)
        return updated
    }
}

// MARK: - Model Conversions

extension FollowResponse {
    func toModel() -> FollowData {
        FollowData(
            createdAt: createdAt,
            custom: custom,
            followerRole: followerRole,
            pushPreference: pushPreference.rawValue,
            requestAcceptedAt: requestAcceptedAt,
            requestRejectedAt: requestRejectedAt,
            sourceFeed: sourceFeed.toModel(),
            status: status,
            targetFeed: targetFeed.toModel(),
            updatedAt: updatedAt
        )
    }
}
