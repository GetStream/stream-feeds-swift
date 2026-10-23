//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class ImageRuleParameters: Sendable, Encodable, JSONEncodable {
    public let harmLabels: [String]?
    public let threshold: Int?
    public let timeWindow: String?

    public init(harmLabels: [String]? = nil, threshold: Int? = nil, timeWindow: String? = nil) {
        self.harmLabels = harmLabels
        self.threshold = threshold
        self.timeWindow = timeWindow
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(harmLabels, forKey: .harmLabels)
        try container.encodeIfPresent(threshold, forKey: .threshold)
        try container.encodeIfPresent(timeWindow, forKey: .timeWindow)
    }
}

extension ImageRuleParameters: Hashable {
    public static func == (lhs: ImageRuleParameters, rhs: ImageRuleParameters) -> Bool {
        lhs.harmLabels == rhs.harmLabels &&
            lhs.threshold == rhs.threshold &&
            lhs.timeWindow == rhs.timeWindow
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(harmLabels)
        hasher.combine(threshold)
        hasher.combine(timeWindow)
    }
}
