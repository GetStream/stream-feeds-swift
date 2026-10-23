//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class ActivityPinResponse: Sendable, Decodable {
    public let activity: ActivityResponse
    /// When the pin was created
    public let createdAt: Date
    /// ID of the feed where activity is pinned
    public let feed: String
    /// When the pin was last updated
    public let updatedAt: Date
    /// User response object
    public let user: UserResponse

    public init(activity: ActivityResponse, createdAt: Date, feed: String, updatedAt: Date, user: UserResponse) {
        self.activity = activity
        self.createdAt = createdAt
        self.feed = feed
        self.updatedAt = updatedAt
        self.user = user
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.activity = try container.decode(ActivityResponse.self, forKey: .activity)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.feed = try container.decode(String.self, forKey: .feed)
        self.updatedAt = try container.decode(Date.self, forKey: .updatedAt)
        self.user = try container.decode(UserResponse.self, forKey: .user)
    }
}

extension ActivityPinResponse: Hashable {
    public static func == (lhs: ActivityPinResponse, rhs: ActivityPinResponse) -> Bool {
        lhs.activity == rhs.activity &&
            lhs.createdAt == rhs.createdAt &&
            lhs.feed == rhs.feed &&
            lhs.updatedAt == rhs.updatedAt &&
            lhs.user == rhs.user
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(activity)
        hasher.combine(createdAt)
        hasher.combine(feed)
        hasher.combine(updatedAt)
        hasher.combine(user)
    }
}
