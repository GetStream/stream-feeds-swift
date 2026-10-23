//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class SingleFollowResponse: Sendable, Codable, JSONEncodable {
    public let duration: String
    public let follow: FollowResponse
    /// Whether a notification activity was successfully created
    public let notificationCreated: Bool?

    public init(duration: String, follow: FollowResponse, notificationCreated: Bool? = nil) {
        self.duration = duration
        self.follow = follow
        self.notificationCreated = notificationCreated
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.duration = try container.decode(String.self, forKey: .duration)
        self.follow = try container.decode(FollowResponse.self, forKey: .follow)
        self.notificationCreated = try container.decodeIfPresent(Bool.self, forKey: .notificationCreated)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(duration, forKey: .duration)
        try container.encode(follow, forKey: .follow)
        try container.encodeIfPresent(notificationCreated, forKey: .notificationCreated)
    }
}

extension SingleFollowResponse: Hashable {
    public static func == (lhs: SingleFollowResponse, rhs: SingleFollowResponse) -> Bool {
        lhs.duration == rhs.duration &&
            lhs.follow == rhs.follow &&
            lhs.notificationCreated == rhs.notificationCreated
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(duration)
        hasher.combine(follow)
        hasher.combine(notificationCreated)
    }
}
