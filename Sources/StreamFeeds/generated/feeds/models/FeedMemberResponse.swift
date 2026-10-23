//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class FeedMemberResponse: @unchecked Sendable, Codable, JSONEncodable {
    public enum FeedMemberResponseStatus: String, Sendable, Codable, CaseIterable {
        case member
        case pending
        case rejected
        case unknown = "_unknown"

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let decodedValue = try? container.decode(String.self),
               let value = Self(rawValue: decodedValue) {
                self = value
            } else {
                self = .unknown
            }
        }
    }

    /// When the membership was created
    public var createdAt: Date
    /// Custom data for the membership
    public var custom: [String: RawJSON]?
    /// When the invite was accepted
    public var inviteAcceptedAt: Date?
    /// When the invite was rejected
    public var inviteRejectedAt: Date?
    public var membershipLevel: MembershipLevelResponse?
    /// Role of the member in the feed
    public var role: String
    /// Status of the membership. One of: member, pending, rejected
    public var status: FeedMemberResponseStatus
    /// When the membership was last updated
    public var updatedAt: Date
    /// User response object
    public var user: UserResponse

    public init(
        createdAt: Date,
        custom: [String: RawJSON]? = nil,
        inviteAcceptedAt: Date? = nil,
        inviteRejectedAt: Date? = nil,
        membershipLevel: MembershipLevelResponse? = nil,
        role: String,
        status: FeedMemberResponseStatus,
        updatedAt: Date,
        user: UserResponse
    ) {
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

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case createdAt = "created_at"
        case custom
        case inviteAcceptedAt = "invite_accepted_at"
        case inviteRejectedAt = "invite_rejected_at"
        case membershipLevel = "membership_level"
        case role
        case status
        case updatedAt = "updated_at"
        case user
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
