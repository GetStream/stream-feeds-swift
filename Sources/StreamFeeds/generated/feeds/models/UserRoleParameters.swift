//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UserRoleParameters: Sendable, Codable, JSONEncodable {
    public let `operator`: String?
    public let role: String?

    public init(operator: String? = nil, role: String? = nil) {
        self.operator = `operator`
        self.role = role
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.operator = try container.decodeIfPresent(String.self, forKey: .operator)
        self.role = try container.decodeIfPresent(String.self, forKey: .role)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(`operator`, forKey: .operator)
        try container.encodeIfPresent(role, forKey: .role)
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
