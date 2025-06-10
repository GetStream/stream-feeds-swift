//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public struct FollowData: Sendable {
    public typealias FollowStatus = FollowResponse.FollowStatus
    
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
    
    init(from response: FollowResponse) {
        self.createdAt = response.createdAt
        self.custom = response.custom
        self.followerRole = response.followerRole
        self.pushPreference = response.pushPreference
        self.requestAcceptedAt = response.requestAcceptedAt
        self.requestRejectedAt = response.requestRejectedAt
        self.sourceFeed = FeedData(from: response.sourceFeed)
        self.status = response.status
        self.targetFeed = FeedData(from: response.targetFeed)
        self.updatedAt = response.updatedAt
    }
    
    var isFollower: Bool {
        status == .accepted
    }
    
    var isFollowing: Bool {
        status == .accepted
    }
    
    var isFollowRequest: Bool {
        status == .pending
    }
    
    func isFollower(of feedId: String) -> Bool {
        isFollower && targetFeed.id == feedId
    }
    
    func isFollowing(feedId: String) -> Bool {
        isFollowing && sourceFeed.id == feedId
    }
}

extension FollowData: Identifiable {
    // TODO: Review
    public var id: String {
        "\(sourceFeed.fid)\(targetFeed.fid)\(createdAt.timeIntervalSince1970)"
    }
}
