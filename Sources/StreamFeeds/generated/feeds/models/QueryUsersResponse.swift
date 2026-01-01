//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class QueryUsersResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var duration: String
    public var users: [FullUserResponse]

    public init(duration: String, users: [FullUserResponse]) {
        self.duration = duration
        self.users = users
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case duration
        case users
    }

    public static func == (lhs: QueryUsersResponse, rhs: QueryUsersResponse) -> Bool {
        lhs.duration == rhs.duration &&
            lhs.users == rhs.users
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(duration)
        hasher.combine(users)
    }
}
