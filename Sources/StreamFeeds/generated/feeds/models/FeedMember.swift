import Foundation
import StreamCore

public final class FeedMember: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var createdAt: Date
    public var custom: [String: RawJSON]?
    public var feed: Feed?
    public var request: Bool?
    public var requestAcceptedAt: Date?
    public var requestRejectedAt: Date?
    public var role: String?
    public var status: String?
    public var updatedAt: Date
    public var user: UserResponse?

    public init(createdAt: Date, custom: [String: RawJSON]? = nil, feed: Feed? = nil, request: Bool? = nil, requestAcceptedAt: Date? = nil, requestRejectedAt: Date? = nil, role: String? = nil, status: String? = nil, updatedAt: Date, user: UserResponse? = nil) {
        self.createdAt = createdAt
        self.custom = custom
        self.feed = feed
        self.request = request
        self.requestAcceptedAt = requestAcceptedAt
        self.requestRejectedAt = requestRejectedAt
        self.role = role
        self.status = status
        self.updatedAt = updatedAt
        self.user = user
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case createdAt = "created_at"
        case custom
        case feed
        case request
        case requestAcceptedAt = "request_accepted_at"
        case requestRejectedAt = "request_rejected_at"
        case role
        case status
        case updatedAt = "updated_at"
        case user
    }

    public static func == (lhs: FeedMember, rhs: FeedMember) -> Bool {
        lhs.createdAt == rhs.createdAt &&
            lhs.custom == rhs.custom &&
            lhs.feed == rhs.feed &&
            lhs.request == rhs.request &&
            lhs.requestAcceptedAt == rhs.requestAcceptedAt &&
            lhs.requestRejectedAt == rhs.requestRejectedAt &&
            lhs.role == rhs.role &&
            lhs.status == rhs.status &&
            lhs.updatedAt == rhs.updatedAt &&
            lhs.user == rhs.user
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(createdAt)
        hasher.combine(custom)
        hasher.combine(feed)
        hasher.combine(request)
        hasher.combine(requestAcceptedAt)
        hasher.combine(requestRejectedAt)
        hasher.combine(role)
        hasher.combine(status)
        hasher.combine(updatedAt)
        hasher.combine(user)
    }
}
