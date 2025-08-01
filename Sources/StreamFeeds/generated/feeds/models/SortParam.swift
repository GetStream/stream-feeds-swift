//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class SortParam: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var direction: Int
    public var field: String

    public init(direction: Int, field: String) {
        self.direction = direction
        self.field = field
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case direction
        case field
    }

    public static func == (lhs: SortParam, rhs: SortParam) -> Bool {
        lhs.direction == rhs.direction &&
            lhs.field == rhs.field
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(direction)
        hasher.combine(field)
    }
}
