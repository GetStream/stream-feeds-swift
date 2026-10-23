//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UserCustomPropertyParameters: Sendable, Encodable, JSONEncodable {
    public let `operator`: String?
    public let propertyKey: String?

    public init(operator: String? = nil, propertyKey: String? = nil) {
        self.operator = `operator`
        self.propertyKey = propertyKey
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
