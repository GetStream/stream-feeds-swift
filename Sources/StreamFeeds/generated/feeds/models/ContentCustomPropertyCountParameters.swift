//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class ContentCustomPropertyCountParameters: Sendable, Codable, JSONEncodable {
    public let `operator`: String?
    public let propertyKey: String?
    public let threshold: Int?
    public let timeWindow: String?

    public init(operator: String? = nil, propertyKey: String? = nil, threshold: Int? = nil, timeWindow: String? = nil) {
        self.operator = `operator`
        self.propertyKey = propertyKey
        self.threshold = threshold
        self.timeWindow = timeWindow
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.operator = try container.decodeIfPresent(String.self, forKey: .operator)
        self.propertyKey = try container.decodeIfPresent(String.self, forKey: .propertyKey)
        self.threshold = try container.decodeIfPresent(Int.self, forKey: .threshold)
        self.timeWindow = try container.decodeIfPresent(String.self, forKey: .timeWindow)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(`operator`, forKey: .operator)
        try container.encodeIfPresent(propertyKey, forKey: .propertyKey)
        try container.encodeIfPresent(threshold, forKey: .threshold)
        try container.encodeIfPresent(timeWindow, forKey: .timeWindow)
    }
}

extension ContentCustomPropertyCountParameters: Hashable {
    public static func == (lhs: ContentCustomPropertyCountParameters, rhs: ContentCustomPropertyCountParameters) -> Bool {
        lhs.operator == rhs.operator &&
            lhs.propertyKey == rhs.propertyKey &&
            lhs.threshold == rhs.threshold &&
            lhs.timeWindow == rhs.timeWindow
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(`operator`)
        hasher.combine(propertyKey)
        hasher.combine(threshold)
        hasher.combine(timeWindow)
    }
}
