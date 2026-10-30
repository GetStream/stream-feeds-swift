//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class FeedMemberResponse: Sendable, Decodable {
    /// When the membership was created
    public let createdAt: Date
    /// Custom data for the membership
    public let custom: [String: RawJSON]?
    /// When the invite was accepted
    public let inviteAcceptedAt: Date?
    /// When the invite was rejected
    public let inviteRejectedAt: Date?
    public let membershipLevel: MembershipLevelResponse?
    /// Role of the member in the feed
    public let role: String
    /// Status of the membership. One of: member, pending, rejected
    public let status: FeedMemberStatus
    /// When the membership was last updated
    public let updatedAt: Date
    /// User response object
    public let user: UserResponse

    public init(createdAt: Date, custom: [String: RawJSON]? = nil, inviteAcceptedAt: Date? = nil, inviteRejectedAt: Date? = nil, membershipLevel: MembershipLevelResponse? = nil, role: String, status: FeedMemberStatus, updatedAt: Date, user: UserResponse) {
        self.createdAt = createdAt
        self.custom = custom
        self.inviteAcceptedAt = inviteAcceptedAt
        self.inviteRejectedAt = inviteRejectedAt
        self.membershipLevel = membershipLevel
        self.role = role
        self.status = status
        self.updatedAt = updatedAt
        self.user = user
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.custom = try container.decodeIfPresent([String: RawJSON].self, forKey: .custom)
        self.inviteAcceptedAt = try container.decodeIfPresent(Date.self, forKey: .inviteAcceptedAt)
        self.inviteRejectedAt = try container.decodeIfPresent(Date.self, forKey: .inviteRejectedAt)
        self.membershipLevel = try container.decodeIfPresent(MembershipLevelResponse.self, forKey: .membershipLevel)
        self.role = try container.decode(String.self, forKey: .role)
        self.status = try container.decode(FeedMemberStatus.self, forKey: .status)
        self.updatedAt = try container.decode(Date.self, forKey: .updatedAt)
        self.user = try container.decode(UserResponse.self, forKey: .user)
    }
}

extension FeedMemberResponse: Hashable {
    public static func == (lhs: FeedMemberResponse, rhs: FeedMemberResponse) -> Bool {
        lhs.createdAt == rhs.createdAt &&
            lhs.custom == rhs.custom &&
            lhs.inviteAcceptedAt == rhs.inviteAcceptedAt &&
            lhs.inviteRejectedAt == rhs.inviteRejectedAt &&
            lhs.membershipLevel == rhs.membershipLevel &&
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
        hasher.combine(membershipLevel)
        hasher.combine(role)
        hasher.combine(status)
        hasher.combine(updatedAt)
        hasher.combine(user)
    }
}
