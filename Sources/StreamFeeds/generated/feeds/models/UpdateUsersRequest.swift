//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UpdateUsersRequest: @unchecked Sendable, Codable, JSONEncodable {
    /// Object containing users
    public var users: [String: UserRequest]

    public init(users: [String: UserRequest]) {
        self.users = users
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case users
    }
}

extension UpdateUsersRequest: Hashable {
    public static func == (lhs: UpdateUsersRequest, rhs: UpdateUsersRequest) -> Bool {
        lhs.users == rhs.users
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(users)
    }
}
