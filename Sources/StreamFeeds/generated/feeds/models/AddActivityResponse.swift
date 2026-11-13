//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class AddActivityResponse: Sendable, Decodable {
    public let activity: ActivityResponse
    /// Number of mention notification activities created for mentioned users
    public let mentionNotificationsCreated: Int?

    public init(activity: ActivityResponse, mentionNotificationsCreated: Int? = nil) {
        self.activity = activity
        self.mentionNotificationsCreated = mentionNotificationsCreated
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.activity = try container.decode(ActivityResponse.self, forKey: .activity)
        self.mentionNotificationsCreated = try container.decodeIfPresent(Int.self, forKey: .mentionNotificationsCreated)
    }
}

extension AddActivityResponse: Hashable {
    public static func == (lhs: AddActivityResponse, rhs: AddActivityResponse) -> Bool {
        lhs.activity == rhs.activity &&
            lhs.mentionNotificationsCreated == rhs.mentionNotificationsCreated
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(activity)
        hasher.combine(mentionNotificationsCreated)
    }
}
