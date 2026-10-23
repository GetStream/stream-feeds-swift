//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class ShareResponse: Sendable, Codable, JSONEncodable {
    /// ID of the sharing (child) activity
    public let activityId: String
    /// When the share occurred
    public let createdAt: Date
    /// User response object
    public let user: UserResponse

    public init(activityId: String, createdAt: Date, user: UserResponse) {
        self.activityId = activityId
        self.createdAt = createdAt
        self.user = user
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.activityId = try container.decode(String.self, forKey: .activityId)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.user = try container.decode(UserResponse.self, forKey: .user)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(activityId, forKey: .activityId)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(user, forKey: .user)
    }
}

extension ShareResponse: Hashable {
    public static func == (lhs: ShareResponse, rhs: ShareResponse) -> Bool {
        lhs.activityId == rhs.activityId &&
            lhs.createdAt == rhs.createdAt &&
            lhs.user == rhs.user
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(activityId)
        hasher.combine(createdAt)
        hasher.combine(user)
    }
}
