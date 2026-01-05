//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class RejectFeedMemberInviteResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
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

    public static func == (lhs: RejectFeedMemberInviteResponse, rhs: RejectFeedMemberInviteResponse) -> Bool {
        lhs.duration == rhs.duration &&
            lhs.member == rhs.member
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(duration)
        hasher.combine(member)
    }
}
