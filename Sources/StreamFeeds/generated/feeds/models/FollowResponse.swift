//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class FollowResponsePushPreference: RawRepresentable, Codable, Hashable, Sendable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public static let all = FollowResponsePushPreference(rawValue: "all")
    public static let none = FollowResponsePushPreference(rawValue: "none")
}

public final class FollowResponseStatus: RawRepresentable, Codable, Hashable, Sendable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public static let accepted = FollowResponseStatus(rawValue: "accepted")
    public static let pending = FollowResponseStatus(rawValue: "pending")
    public static let rejected = FollowResponseStatus(rawValue: "rejected")
}

public final class FollowResponse: Sendable, Codable, JSONEncodable {
    /// When the follow relationship was created
    public let createdAt: Date
    /// Custom data for the follow relationship
    public let custom: [String: RawJSON]?
    /// Role of the follower (source user) in the follow relationship, as stored. A reserved name, or a role your app no longer defines, is reported as stored but evaluated as 'feed_follower'.
    public let followerRole: String
    /// Push preference for notifications. One of: all, none
    public let pushPreference: FollowResponsePushPreference
    /// When the follow request was accepted
    public let requestAcceptedAt: Date?
    /// When the follow request was rejected
    public let requestRejectedAt: Date?
    public let sourceFeed: FeedResponse
    /// Status of the follow relationship. One of: accepted, pending, rejected
    public let status: FollowResponseStatus
    public let targetFeed: FeedResponse
    /// When the follow relationship was last updated
    public let updatedAt: Date

    public init(createdAt: Date, custom: [String: RawJSON]? = nil, followerRole: String, pushPreference: FollowResponsePushPreference, requestAcceptedAt: Date? = nil, requestRejectedAt: Date? = nil, sourceFeed: FeedResponse, status: FollowResponseStatus, targetFeed: FeedResponse, updatedAt: Date) {
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
        self.pushPreference = try container.decode(FollowResponsePushPreference.self, forKey: .pushPreference)
        self.requestAcceptedAt = try container.decodeIfPresent(Date.self, forKey: .requestAcceptedAt)
        self.requestRejectedAt = try container.decodeIfPresent(Date.self, forKey: .requestRejectedAt)
        self.sourceFeed = try container.decode(FeedResponse.self, forKey: .sourceFeed)
        self.status = try container.decode(FollowResponseStatus.self, forKey: .status)
        self.targetFeed = try container.decode(FeedResponse.self, forKey: .targetFeed)
        self.updatedAt = try container.decode(Date.self, forKey: .updatedAt)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encodeIfPresent(custom, forKey: .custom)
        try container.encode(followerRole, forKey: .followerRole)
        try container.encode(pushPreference, forKey: .pushPreference)
        try container.encodeIfPresent(requestAcceptedAt, forKey: .requestAcceptedAt)
        try container.encodeIfPresent(requestRejectedAt, forKey: .requestRejectedAt)
        try container.encode(sourceFeed, forKey: .sourceFeed)
        try container.encode(status, forKey: .status)
        try container.encode(targetFeed, forKey: .targetFeed)
        try container.encode(updatedAt, forKey: .updatedAt)
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
