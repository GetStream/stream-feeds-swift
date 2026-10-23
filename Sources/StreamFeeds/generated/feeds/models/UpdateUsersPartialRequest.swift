//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UpdateUsersPartialRequest: Sendable, Codable, JSONEncodable {
    public let users: [UpdateUserPartialRequest]

    public init(users: [UpdateUserPartialRequest]) {
        self.users = users
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.users = try container.decode([UpdateUserPartialRequest].self, forKey: .users)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(users, forKey: .users)
    }
}

extension UpdateUsersPartialRequest: Hashable {
    public static func == (lhs: UpdateUsersPartialRequest, rhs: UpdateUsersPartialRequest) -> Bool {
        lhs.users == rhs.users
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(users)
    }
}
