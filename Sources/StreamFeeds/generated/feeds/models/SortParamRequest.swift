//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class SortParamRequest: @unchecked Sendable, Codable, JSONEncodable {
    /// Direction of sorting, 1 for Ascending, -1 for Descending, default is 1. One of: -1, 1
    public var direction: Int?
    /// Name of field to sort by
    public var field: String?
    /// Type of field to sort by. Empty string or omitted means string type (default). One of: number, boolean
    public var type: String?

    public init(direction: Int? = nil, field: String? = nil) {
        self.direction = direction
        self.field = field
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case direction
        case field
        case type
    }
}

extension SortParamRequest: Hashable {
    public static func == (lhs: SortParamRequest, rhs: SortParamRequest) -> Bool {
        lhs.direction == rhs.direction &&
            lhs.field == rhs.field &&
            lhs.type == rhs.type
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(direction)
        hasher.combine(field)
        hasher.combine(type)
    }
}
