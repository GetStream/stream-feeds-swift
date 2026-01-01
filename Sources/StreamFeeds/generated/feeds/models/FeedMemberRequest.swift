//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class FeedMemberRequest: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var custom: [String: RawJSON]?
    public var invite: Bool?
    public var membershipLevel: String?
    public var role: String?
    public var userId: String

    public init(custom: [String: RawJSON]? = nil, invite: Bool? = nil, membershipLevel: String? = nil, role: String? = nil, userId: String) {
        self.custom = custom
        self.invite = invite
        self.membershipLevel = membershipLevel
        self.role = role
        self.userId = userId
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case custom
        case invite
        case membershipLevel = "membership_level"
        case role
        case userId = "user_id"
    }

    public static func == (lhs: FeedMemberRequest, rhs: FeedMemberRequest) -> Bool {
        lhs.custom == rhs.custom &&
            lhs.invite == rhs.invite &&
            lhs.membershipLevel == rhs.membershipLevel &&
            lhs.role == rhs.role &&
            lhs.userId == rhs.userId
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(custom)
        hasher.combine(invite)
        hasher.combine(membershipLevel)
        hasher.combine(role)
        hasher.combine(userId)
    }
}
