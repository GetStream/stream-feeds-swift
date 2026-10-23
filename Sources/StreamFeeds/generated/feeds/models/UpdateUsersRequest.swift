//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UpdateUsersRequest: Sendable, Encodable, JSONEncodable {
    /// Object containing users
    public let users: [String: UserRequest]

    public init(users: [String: UserRequest]) {
        self.users = users
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(users, forKey: .users)
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
