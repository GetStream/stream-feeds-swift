//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class FeedMemberRequest: @unchecked Sendable, Codable, JSONEncodable {
    /// Custom data for the member
    public var custom: [String: RawJSON]?
    /// Whether this is an invite to become a member
    public var invite: Bool?
    /// ID of the user to add as a member
    public var userId: String

    public init(custom: [String: RawJSON]? = nil, invite: Bool? = nil, userId: String) {
        self.custom = custom
        self.invite = invite
        self.userId = userId
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case custom
        case invite
        case userId = "user_id"
    }
}

extension FeedMemberRequest: Hashable {
    public static func == (lhs: FeedMemberRequest, rhs: FeedMemberRequest) -> Bool {
        lhs.custom == rhs.custom &&
            lhs.invite == rhs.invite &&
            lhs.userId == rhs.userId
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(custom)
        hasher.combine(invite)
        hasher.combine(userId)
    }
}
