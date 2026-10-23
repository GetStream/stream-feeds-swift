//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class ContentCustomPropertyCountParameters: @unchecked Sendable, Codable, JSONEncodable {
    public var `operator`: String?
    public var propertyKey: String?
    public var threshold: Int?
    public var timeWindow: String?

    public init(
        operator: String? = nil,
        propertyKey: String? = nil,
        threshold: Int? = nil,
        timeWindow: String? = nil
    ) {
        self.operator = `operator`
        self.propertyKey = propertyKey
        self.threshold = threshold
        self.timeWindow = timeWindow
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case `operator`
        case propertyKey = "property_key"
        case threshold
        case timeWindow = "time_window"
    }
}

extension ContentCustomPropertyCountParameters: Hashable {
    public static func == (
        lhs: ContentCustomPropertyCountParameters,
        rhs: ContentCustomPropertyCountParameters
    ) -> Bool {
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
