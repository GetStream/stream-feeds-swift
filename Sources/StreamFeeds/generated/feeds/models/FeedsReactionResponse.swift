//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class FeedsReactionResponse: Sendable, Decodable {
    public let activityId: String
    public let commentId: String?
    public let createdAt: Date
    public let custom: [String: RawJSON]?
    public let type: String
    public let updatedAt: Date
    /// User response object
    public let user: UserResponse

    public init(activityId: String, commentId: String? = nil, createdAt: Date, custom: [String: RawJSON]? = nil, type: String, updatedAt: Date, user: UserResponse) {
        self.activityId = activityId
        self.commentId = commentId
        self.createdAt = createdAt
        self.custom = custom
        self.type = type
        self.updatedAt = updatedAt
        self.user = user
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.activityId = try container.decode(String.self, forKey: .activityId)
        self.commentId = try container.decodeIfPresent(String.self, forKey: .commentId)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.custom = try container.decodeIfPresent([String: RawJSON].self, forKey: .custom)
        self.type = try container.decode(String.self, forKey: .type)
        self.updatedAt = try container.decode(Date.self, forKey: .updatedAt)
        self.user = try container.decode(UserResponse.self, forKey: .user)
    }
}

extension FeedsReactionResponse: Hashable {
    public static func == (lhs: FeedsReactionResponse, rhs: FeedsReactionResponse) -> Bool {
        lhs.activityId == rhs.activityId &&
            lhs.commentId == rhs.commentId &&
            lhs.createdAt == rhs.createdAt &&
            lhs.custom == rhs.custom &&
            lhs.type == rhs.type &&
            lhs.updatedAt == rhs.updatedAt &&
            lhs.user == rhs.user
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(activityId)
        hasher.combine(commentId)
        hasher.combine(createdAt)
        hasher.combine(custom)
        hasher.combine(type)
        hasher.combine(updatedAt)
        hasher.combine(user)
    }
}
