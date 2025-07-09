//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class LabelThresholds: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var block: Float?
    public var flag: Float?

    public init(block: Float? = nil, flag: Float? = nil) {
        self.block = block
        self.flag = flag
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case block
        case flag
    }

    public static func == (lhs: LabelThresholds, rhs: LabelThresholds) -> Bool {
        lhs.block == rhs.block &&
            lhs.flag == rhs.flag
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(block)
        hasher.combine(flag)
    }
}
