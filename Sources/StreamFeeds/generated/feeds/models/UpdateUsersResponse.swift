//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UpdateUsersResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var duration: String
    public var membershipDeletionTaskId: String
    public var users: [String: FullUserResponse]

    public init(duration: String, membershipDeletionTaskId: String, users: [String: FullUserResponse]) {
        self.duration = duration
        self.membershipDeletionTaskId = membershipDeletionTaskId
        self.users = users
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case duration
        case membershipDeletionTaskId = "membership_deletion_task_id"
        case users
    }

    public static func == (lhs: UpdateUsersResponse, rhs: UpdateUsersResponse) -> Bool {
        lhs.duration == rhs.duration &&
            lhs.membershipDeletionTaskId == rhs.membershipDeletionTaskId &&
            lhs.users == rhs.users
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(duration)
        hasher.combine(membershipDeletionTaskId)
        hasher.combine(users)
    }
}
