//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class FeedMemberRequest: Sendable, Encodable, JSONEncodable {
    /// Custom data for the member
    public let custom: [String: RawJSON]?
    /// Whether this is an invite to become a member
    public let invite: Bool?
    /// ID of the user to add as a member
    public let userId: String

    public init(custom: [String: RawJSON]? = nil, invite: Bool? = nil, userId: String) {
        self.custom = custom
        self.invite = invite
        self.userId = userId
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(custom, forKey: .custom)
        try container.encodeIfPresent(invite, forKey: .invite)
        try container.encode(userId, forKey: .userId)
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
