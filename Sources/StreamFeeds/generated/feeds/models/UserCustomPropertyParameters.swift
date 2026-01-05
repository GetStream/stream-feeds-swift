//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UserCustomPropertyParameters: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var `operator`: String?
    public var propertyKey: String?

    public init(operator: String? = nil, propertyKey: String? = nil) {
        self.operator = `operator`
        self.propertyKey = propertyKey
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case `operator`
        case propertyKey = "property_key"
    }

    public static func == (lhs: UserCustomPropertyParameters, rhs: UserCustomPropertyParameters) -> Bool {
        lhs.operator == rhs.operator &&
            lhs.propertyKey == rhs.propertyKey
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(`operator`)
        hasher.combine(propertyKey)
    }
}
