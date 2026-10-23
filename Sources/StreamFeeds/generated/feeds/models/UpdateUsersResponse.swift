//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UpdateUsersResponse: Sendable, Codable, JSONEncodable {
    /// Duration of the request in milliseconds
    public let duration: String
    /// Deprecated: Always empty. Removing a user from a team no longer deletes their memberships in that team's channels, so there is no task to poll.
    @available(*, deprecated, message: "Always empty. Removing a user from a team no longer deletes their memberships in that team's channels, so there is no task to poll.")
    public var membershipDeletionTaskId: String { _membershipDeletionTaskId }
    private let _membershipDeletionTaskId: String
    /// Object containing users
    public let users: [String: FullUserResponse]

    public init(duration: String, membershipDeletionTaskId: String, users: [String: FullUserResponse]) {
        self.duration = duration
        self._membershipDeletionTaskId = membershipDeletionTaskId
        self.users = users
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.duration = try container.decode(String.self, forKey: .duration)
        self._membershipDeletionTaskId = try container.decode(String.self, forKey: .membershipDeletionTaskId)
        self.users = try container.decode([String: FullUserResponse].self, forKey: .users)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(duration, forKey: .duration)
        try container.encode(_membershipDeletionTaskId, forKey: .membershipDeletionTaskId)
        try container.encode(users, forKey: .users)
    }
}

extension UpdateUsersResponse: Hashable {
    public static func == (lhs: UpdateUsersResponse, rhs: UpdateUsersResponse) -> Bool {
        lhs.duration == rhs.duration &&
            lhs._membershipDeletionTaskId == rhs._membershipDeletionTaskId &&
            lhs.users == rhs.users
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(duration)
        hasher.combine(_membershipDeletionTaskId)
        hasher.combine(users)
    }
}
