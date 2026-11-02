//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class AIVideoConfigResponse: Sendable, Decodable {
    public let async: Bool?
    public let enabled: Bool
    public let rules: [AWSRekognitionRule]

    public init(async: Bool? = nil, enabled: Bool, rules: [AWSRekognitionRule]) {
        self.async = async
        self.enabled = enabled
        self.rules = rules
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.async = try container.decodeIfPresent(Bool.self, forKey: .async)
        self.enabled = try container.decode(Bool.self, forKey: .enabled)
        self.rules = try container.decode([AWSRekognitionRule].self, forKey: .rules)
    }
}

extension AIVideoConfigResponse: Hashable {
    public static func == (lhs: AIVideoConfigResponse, rhs: AIVideoConfigResponse) -> Bool {
        lhs.async == rhs.async &&
            lhs.enabled == rhs.enabled &&
            lhs.rules == rhs.rules
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(async)
        hasher.combine(enabled)
        hasher.combine(rules)
    }
}
