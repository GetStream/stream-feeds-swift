import Foundation
import StreamCore

public final class FollowResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public enum FollowStatus: String, Sendable, Codable, CaseIterable {
        case accepted
        case pending
        case rejected
        case unknown = "_unknown"

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let decodedValue = try? container.decode(String.self),
               let value = Self(rawValue: decodedValue)
            {
                self = value
            } else {
                self = .unknown
            }
        }
    }

    public var createdAt: Date
    public var custom: [String: RawJSON]?
    public var followerRole: String
    public var pushPreference: String
    public var requestAcceptedAt: Date?
    public var requestRejectedAt: Date?
    public var sourceFeed: FeedResponse
    public var status: FollowStatus
    public var targetFeed: FeedResponse
    public var updatedAt: Date

    public init(createdAt: Date, custom: [String: RawJSON]? = nil, followerRole: String, pushPreference: String, requestAcceptedAt: Date? = nil, requestRejectedAt: Date? = nil, sourceFeed: FeedResponse, status: FollowStatus, targetFeed: FeedResponse, updatedAt: Date) {
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

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case createdAt = "created_at"
        case custom
        case followerRole = "follower_role"
        case pushPreference = "push_preference"
        case requestAcceptedAt = "request_accepted_at"
        case requestRejectedAt = "request_rejected_at"
        case sourceFeed = "source_feed"
        case status
        case targetFeed = "target_feed"
        case updatedAt = "updated_at"
    }

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
