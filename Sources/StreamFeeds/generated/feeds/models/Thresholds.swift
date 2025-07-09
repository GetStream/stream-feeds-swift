//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class Thresholds: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var explicit: LabelThresholds?
    public var spam: LabelThresholds?
    public var toxic: LabelThresholds?

    public init(explicit: LabelThresholds? = nil, spam: LabelThresholds? = nil, toxic: LabelThresholds? = nil) {
        self.explicit = explicit
        self.spam = spam
        self.toxic = toxic
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case explicit
        case spam
        case toxic
    }

    public static func == (lhs: Thresholds, rhs: Thresholds) -> Bool {
        lhs.explicit == rhs.explicit &&
            lhs.spam == rhs.spam &&
            lhs.toxic == rhs.toxic
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(explicit)
        hasher.combine(spam)
        hasher.combine(toxic)
    }
}
