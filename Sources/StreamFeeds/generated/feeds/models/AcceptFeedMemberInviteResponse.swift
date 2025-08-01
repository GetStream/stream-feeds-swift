//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class AcceptFeedMemberInviteResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var duration: String
    public var member: FeedMemberResponse

    public init(duration: String, member: FeedMemberResponse) {
        self.duration = duration
        self.member = member
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case duration
        case member
    }

    public static func == (lhs: AcceptFeedMemberInviteResponse, rhs: AcceptFeedMemberInviteResponse) -> Bool {
        lhs.duration == rhs.duration &&
            lhs.member == rhs.member
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(duration)
        hasher.combine(member)
    }
}
