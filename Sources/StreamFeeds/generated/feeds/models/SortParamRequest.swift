//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class SortParamRequest: Sendable, Codable, JSONEncodable {
    /// Direction of sorting, 1 for Ascending, -1 for Descending, default is 1. One of: -1, 1
    public let direction: Int?
    /// Name of field to sort by
    public let field: String?
    /// Type of field to sort by. Empty string or omitted means string type (default). One of: number, boolean
    public let type: String?

    public init(direction: Int? = nil, field: String? = nil, type: String? = nil) {
        self.direction = direction
        self.field = field
        self.type = type
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.direction = try container.decodeIfPresent(Int.self, forKey: .direction)
        self.field = try container.decodeIfPresent(String.self, forKey: .field)
        self.type = try container.decodeIfPresent(String.self, forKey: .type)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(direction, forKey: .direction)
        try container.encodeIfPresent(field, forKey: .field)
        try container.encodeIfPresent(type, forKey: .type)
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
