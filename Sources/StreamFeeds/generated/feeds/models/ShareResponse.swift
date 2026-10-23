//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class ShareResponse: @unchecked Sendable, Codable, JSONEncodable {
    /// ID of the sharing (child) activity
    public var activityId: String
    /// When the share occurred
    public var createdAt: Date
    /// User response object
    public var user: UserResponse

    public init(activityId: String, createdAt: Date, user: UserResponse) {
        self.activityId = activityId
        self.createdAt = createdAt
        self.user = user
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case activityId = "activity_id"
        case createdAt = "created_at"
        case user
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
