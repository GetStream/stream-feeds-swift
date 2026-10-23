//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UserRoleParameters: @unchecked Sendable, Codable, JSONEncodable {
    public var `operator`: String?
    public var role: String?

    public init(operator: String? = nil, role: String? = nil) {
        self.operator = `operator`
        self.role = role
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case `operator`
        case role
    }
}

extension UserRoleParameters: Hashable {
    public static func == (lhs: UserRoleParameters, rhs: UserRoleParameters) -> Bool {
        lhs.operator == rhs.operator &&
            lhs.role == rhs.role
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(`operator`)
        hasher.combine(role)
    }
}
