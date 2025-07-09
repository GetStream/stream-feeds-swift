//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UpdateUsersPartialRequest: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var users: [UpdateUserPartialRequest]

    public init(users: [UpdateUserPartialRequest]) {
        self.users = users
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case users
    }

    public static func == (lhs: UpdateUsersPartialRequest, rhs: UpdateUsersPartialRequest) -> Bool {
        lhs.users == rhs.users
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(users)
    }
}
