import Foundation
import StreamCore

public final class FollowResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var createdAt: Date
    public var custom: [String: RawJSON]?
    public var pushPreference: String
    public var request: Bool
    public var requestAcceptedAt: Date?
    public var requestRejectedAt: Date?
    public var role: String?
    public var sourceFeed: FeedResponse
    public var sourceFid: String
    public var status: String
    public var targetFeed: FeedResponse
    public var targetFid: String
    public var updatedAt: Date

    public init(createdAt: Date, custom: [String: RawJSON]? = nil, pushPreference: String, request: Bool, requestAcceptedAt: Date? = nil, requestRejectedAt: Date? = nil, role: String? = nil, sourceFeed: FeedResponse, sourceFid: String, status: String, targetFeed: FeedResponse, targetFid: String, updatedAt: Date) {
        self.createdAt = createdAt
        self.custom = custom
        self.pushPreference = pushPreference
        self.request = request
        self.requestAcceptedAt = requestAcceptedAt
        self.requestRejectedAt = requestRejectedAt
        self.role = role
        self.sourceFeed = sourceFeed
        self.sourceFid = sourceFid
        self.status = status
        self.targetFeed = targetFeed
        self.targetFid = targetFid
        self.updatedAt = updatedAt
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case createdAt = "created_at"
        case custom
        case pushPreference = "push_preference"
        case request
        case requestAcceptedAt = "request_accepted_at"
        case requestRejectedAt = "request_rejected_at"
        case role
        case sourceFeed = "SourceFeed"
        case sourceFid = "source_fid"
        case status
        case targetFeed = "TargetFeed"
        case targetFid = "target_fid"
        case updatedAt = "updated_at"
    }

    public static func == (lhs: FollowResponse, rhs: FollowResponse) -> Bool {
        lhs.createdAt == rhs.createdAt &&
            lhs.custom == rhs.custom &&
            lhs.pushPreference == rhs.pushPreference &&
            lhs.request == rhs.request &&
            lhs.requestAcceptedAt == rhs.requestAcceptedAt &&
            lhs.requestRejectedAt == rhs.requestRejectedAt &&
            lhs.role == rhs.role &&
            lhs.sourceFeed == rhs.sourceFeed &&
            lhs.sourceFid == rhs.sourceFid &&
            lhs.status == rhs.status &&
            lhs.targetFeed == rhs.targetFeed &&
            lhs.targetFid == rhs.targetFid &&
            lhs.updatedAt == rhs.updatedAt
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(createdAt)
        hasher.combine(custom)
        hasher.combine(pushPreference)
        hasher.combine(request)
        hasher.combine(requestAcceptedAt)
        hasher.combine(requestRejectedAt)
        hasher.combine(role)
        hasher.combine(sourceFeed)
        hasher.combine(sourceFid)
        hasher.combine(status)
        hasher.combine(targetFeed)
        hasher.combine(targetFid)
        hasher.combine(updatedAt)
    }
}
