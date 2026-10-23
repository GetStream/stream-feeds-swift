//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UserCustomPropertyParameters: Sendable, Codable, JSONEncodable {
    public let `operator`: String?
    public let propertyKey: String?

    public init(operator: String? = nil, propertyKey: String? = nil) {
        self.operator = `operator`
        self.propertyKey = propertyKey
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.operator = try container.decodeIfPresent(String.self, forKey: .operator)
        self.propertyKey = try container.decodeIfPresent(String.self, forKey: .propertyKey)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(`operator`, forKey: .operator)
        try container.encodeIfPresent(propertyKey, forKey: .propertyKey)
    }
}

extension UserCustomPropertyParameters: Hashable {
    public static func == (lhs: UserCustomPropertyParameters, rhs: UserCustomPropertyParameters) -> Bool {
        lhs.operator == rhs.operator &&
            lhs.propertyKey == rhs.propertyKey
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(`operator`)
        hasher.combine(propertyKey)
    }
}
