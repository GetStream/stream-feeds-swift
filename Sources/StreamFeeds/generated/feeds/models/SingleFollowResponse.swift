//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class SingleFollowResponse: @unchecked Sendable, Codable, JSONEncodable {
    public var duration: String
    public var follow: FollowResponse
    /// Whether a notification activity was successfully created
    public var notificationCreated: Bool?

    public init(duration: String, follow: FollowResponse, notificationCreated: Bool? = nil) {
        self.duration = duration
        self.follow = follow
        self.notificationCreated = notificationCreated
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case duration
        case follow
        case notificationCreated = "notification_created"
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
