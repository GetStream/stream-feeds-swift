//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public struct FeedInfo: Identifiable, Sendable {
    public let createdAt: Date
    public let createdBy: UserResponse
    public let custom: [String: RawJSON]?
    public let deletedAt: Date?
    public let fid: String
    public let followerCount: Int
    public let followingCount: Int
    public let groupId: String
    public let id: String
    public let memberCount: Int
    public let pinCount: Int
    public let updatedAt: Date
    public let visibility: String?
    
    init(from response: FeedResponse) {
        self.createdAt = response.createdAt
        self.createdBy = response.createdBy
        self.custom = response.custom
        self.deletedAt = response.deletedAt
        self.fid = response.fid
        self.followerCount = response.followerCount
        self.followingCount = response.followingCount
        self.groupId = response.groupId
        self.id = response.id
        self.memberCount = response.memberCount
        self.pinCount = response.pinCount
        self.updatedAt = response.updatedAt
        self.visibility = response.visibility
    }
} 
