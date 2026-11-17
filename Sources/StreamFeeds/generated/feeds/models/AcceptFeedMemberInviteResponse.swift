//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class AcceptFeedMemberInviteResponse: Sendable, Decodable {
    public let member: FeedMemberResponse

    public init(member: FeedMemberResponse) {
        self.member = member
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.member = try container.decode(FeedMemberResponse.self, forKey: .member)
    }
}

extension AcceptFeedMemberInviteResponse: Hashable {
    public static func == (lhs: AcceptFeedMemberInviteResponse, rhs: AcceptFeedMemberInviteResponse) -> Bool {
        lhs.member == rhs.member
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(member)
    }
}
