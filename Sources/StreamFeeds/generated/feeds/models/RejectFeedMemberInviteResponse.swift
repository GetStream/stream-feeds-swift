//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class RejectFeedMemberInviteResponse: Sendable, Decodable {
    public let member: FeedMemberResponse

    public init(member: FeedMemberResponse) {
        self.member = member
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.member = try container.decode(FeedMemberResponse.self, forKey: .member)
    }
}

extension RejectFeedMemberInviteResponse: Hashable {
    public static func == (lhs: RejectFeedMemberInviteResponse, rhs: RejectFeedMemberInviteResponse) -> Bool {
        lhs.member == rhs.member
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(member)
    }
}
