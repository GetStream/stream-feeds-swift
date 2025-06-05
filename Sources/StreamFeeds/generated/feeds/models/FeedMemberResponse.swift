import Foundation
import StreamCore

public final class FeedMemberResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var createdAt: Date
    public var custom: [String: RawJSON]?
    public var inviteAcceptedAt: Date?
    public var inviteRejectedAt: Date?
    public var role: String
    public var status: String
    public var updatedAt: Date
    public var user: UserResponse

    public init(createdAt: Date, custom: [String: RawJSON]? = nil, inviteAcceptedAt: Date? = nil, inviteRejectedAt: Date? = nil, role: String, status: String, updatedAt: Date, user: UserResponse) {
        self.createdAt = createdAt
        self.custom = custom
        self.inviteAcceptedAt = inviteAcceptedAt
        self.inviteRejectedAt = inviteRejectedAt
        self.role = role
        self.status = status
        self.updatedAt = updatedAt
        self.user = user
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case createdAt = "created_at"
        case custom
        case inviteAcceptedAt = "invite_accepted_at"
        case inviteRejectedAt = "invite_rejected_at"
        case role
        case status
        case updatedAt = "updated_at"
        case user
    }

    public static func == (lhs: FeedMemberResponse, rhs: FeedMemberResponse) -> Bool {
        lhs.createdAt == rhs.createdAt &&
            lhs.custom == rhs.custom &&
            lhs.inviteAcceptedAt == rhs.inviteAcceptedAt &&
            lhs.inviteRejectedAt == rhs.inviteRejectedAt &&
            lhs.role == rhs.role &&
            lhs.status == rhs.status &&
            lhs.updatedAt == rhs.updatedAt &&
            lhs.user == rhs.user
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(createdAt)
        hasher.combine(custom)
        hasher.combine(inviteAcceptedAt)
        hasher.combine(inviteRejectedAt)
        hasher.combine(role)
        hasher.combine(status)
        hasher.combine(updatedAt)
        hasher.combine(user)
    }
}
