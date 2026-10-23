//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class QueryUsersResponse: Sendable, Decodable {
    /// Duration of the request in milliseconds
    public let duration: String
    /// Array of users as result of filters applied.
    public let users: [FullUserResponse]

    public init(duration: String, users: [FullUserResponse]) {
        self.duration = duration
        self.users = users
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.duration = try container.decode(String.self, forKey: .duration)
        self.users = try container.decode([FullUserResponse].self, forKey: .users)
    }
}

extension QueryUsersResponse: Hashable {
    public static func == (lhs: QueryUsersResponse, rhs: QueryUsersResponse) -> Bool {
        lhs.duration == rhs.duration &&
            lhs.users == rhs.users
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(duration)
        hasher.combine(users)
    }
}
