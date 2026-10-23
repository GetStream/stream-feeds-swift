//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class AcceptFeedMemberInviteResponse: Sendable, Codable, JSONEncodable {
    public let duration: String
    public let member: FeedMemberResponse

    public init(duration: String, member: FeedMemberResponse) {
        self.duration = duration
        self.member = member
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.duration = try container.decode(String.self, forKey: .duration)
        self.member = try container.decode(FeedMemberResponse.self, forKey: .member)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(duration, forKey: .duration)
        try container.encode(member, forKey: .member)
    }
}

extension AcceptFeedMemberInviteResponse: Hashable {
    public static func == (lhs: AcceptFeedMemberInviteResponse, rhs: AcceptFeedMemberInviteResponse) -> Bool {
        lhs.duration == rhs.duration &&
            lhs.member == rhs.member
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(duration)
        hasher.combine(member)
    }
}
