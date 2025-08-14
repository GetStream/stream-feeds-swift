//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class ActivityProcessorConfig: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var config: [String: RawJSON]?
    public var openaiKey: String?
    public var type: String

    public init(config: [String: RawJSON]? = nil, openaiKey: String? = nil, type: String) {
        self.config = config
        self.openaiKey = openaiKey
        self.type = type
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case config
        case openaiKey = "openai_key"
        case type
    }

    public static func == (lhs: ActivityProcessorConfig, rhs: ActivityProcessorConfig) -> Bool {
        lhs.config == rhs.config &&
            lhs.openaiKey == rhs.openaiKey &&
            lhs.type == rhs.type
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(config)
        hasher.combine(openaiKey)
        hasher.combine(type)
    }
}
