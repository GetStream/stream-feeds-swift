//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class FollowResponse: Sendable, Decodable {
    /// When the follow relationship was created
    public let createdAt: Date
    /// Custom data for the follow relationship
    public let custom: [String: RawJSON]?
    /// Role of the follower (source user) in the follow relationship, as stored. A reserved name, or a role your app no longer defines, is reported as stored but evaluated as 'feed_follower'.
    public let followerRole: String
    /// Push preference for notifications. One of: all, none
    public let pushPreference: FollowPushPreference
    /// When the follow request was accepted
    public let requestAcceptedAt: Date?
    /// When the follow request was rejected
    public let requestRejectedAt: Date?
    public let sourceFeed: FeedResponse
    /// Status of the follow relationship. One of: accepted, pending, rejected
    public let status: FollowStatus
    public let targetFeed: FeedResponse
    /// When the follow relationship was last updated
    public let updatedAt: Date

    public init(createdAt: Date, custom: [String: RawJSON]? = nil, followerRole: String, pushPreference: FollowPushPreference, requestAcceptedAt: Date? = nil, requestRejectedAt: Date? = nil, sourceFeed: FeedResponse, status: FollowStatus, targetFeed: FeedResponse, updatedAt: Date) {
        self.createdAt = createdAt
        self.custom = custom
        self.followerRole = followerRole
        self.pushPreference = pushPreference
        self.requestAcceptedAt = requestAcceptedAt
        self.requestRejectedAt = requestRejectedAt
        self.sourceFeed = sourceFeed
        self.status = status
        self.targetFeed = targetFeed
        self.updatedAt = updatedAt
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.custom = try container.decodeIfPresent([String: RawJSON].self, forKey: .custom)
        self.followerRole = try container.decode(String.self, forKey: .followerRole)
        self.pushPreference = try container.decode(FollowPushPreference.self, forKey: .pushPreference)
        self.requestAcceptedAt = try container.decodeIfPresent(Date.self, forKey: .requestAcceptedAt)
        self.requestRejectedAt = try container.decodeIfPresent(Date.self, forKey: .requestRejectedAt)
        self.sourceFeed = try container.decode(FeedResponse.self, forKey: .sourceFeed)
        self.status = try container.decode(FollowStatus.self, forKey: .status)
        self.targetFeed = try container.decode(FeedResponse.self, forKey: .targetFeed)
        self.updatedAt = try container.decode(Date.self, forKey: .updatedAt)
    }
}

extension FollowResponse: Hashable {
    public static func == (lhs: FollowResponse, rhs: FollowResponse) -> Bool {
        lhs.createdAt == rhs.createdAt &&
            lhs.custom == rhs.custom &&
            lhs.followerRole == rhs.followerRole &&
            lhs.pushPreference == rhs.pushPreference &&
            lhs.requestAcceptedAt == rhs.requestAcceptedAt &&
            lhs.requestRejectedAt == rhs.requestRejectedAt &&
            lhs.sourceFeed == rhs.sourceFeed &&
            lhs.status == rhs.status &&
            lhs.targetFeed == rhs.targetFeed &&
            lhs.updatedAt == rhs.updatedAt
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(createdAt)
        hasher.combine(custom)
        hasher.combine(followerRole)
        hasher.combine(pushPreference)
        hasher.combine(requestAcceptedAt)
        hasher.combine(requestRejectedAt)
        hasher.combine(sourceFeed)
        hasher.combine(status)
        hasher.combine(targetFeed)
        hasher.combine(updatedAt)
    }
}
