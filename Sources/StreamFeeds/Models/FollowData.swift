//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public struct FollowData: Sendable {
    public typealias FollowStatus = FollowResponse.FollowResponseStatus
    
    public let createdAt: Date
    public let custom: [String: RawJSON]?
    public let followerRole: String
    public let pushPreference: String
    public let requestAcceptedAt: Date?
    public let requestRejectedAt: Date?
    public let sourceFeed: FeedData
    public let status: FollowStatus
    public let targetFeed: FeedData
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
    
    func isFollower(of fid: FeedId) -> Bool {
        isFollower && targetFeed.fid == fid
    }
    
    func isFollowing(_ fid: FeedId) -> Bool {
        isFollowing && sourceFeed.fid == fid
    }
}

extension FollowData: Identifiable {
    public var id: String {
        "\(sourceFeed.fid)\(targetFeed.fid)\(createdAt.timeIntervalSince1970)"
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
            status: FollowData.FollowStatus(rawValue: status.rawValue) ?? .unknown,
            targetFeed: targetFeed.toModel(),
            updatedAt: updatedAt
        )
    }
}
