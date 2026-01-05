//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class AggregationConfig: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var format: String?
    public var groupSize: Int?

    public init(format: String? = nil, groupSize: Int? = nil) {
        self.format = format
        self.groupSize = groupSize
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case format
        case groupSize = "group_size"
    }

    public static func == (lhs: AggregationConfig, rhs: AggregationConfig) -> Bool {
        lhs.format == rhs.format &&
            lhs.groupSize == rhs.groupSize
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(format)
        hasher.combine(groupSize)
    }
}
