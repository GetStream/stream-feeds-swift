//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class FlagCountRuleParameters: @unchecked Sendable, Codable, JSONEncodable {
    public var threshold: Int?

    public init(threshold: Int? = nil) {
        self.threshold = threshold
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case threshold
    }
}

extension FlagCountRuleParameters: Hashable {
    public static func == (lhs: FlagCountRuleParameters, rhs: FlagCountRuleParameters) -> Bool {
        lhs.threshold == rhs.threshold
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(threshold)
    }
}
