//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class GetConfigResponse: Sendable, Codable, JSONEncodable {
    public let config: ConfigResponse?
    public let duration: String

    public init(config: ConfigResponse? = nil, duration: String) {
        self.config = config
        self.duration = duration
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.config = try container.decodeIfPresent(ConfigResponse.self, forKey: .config)
        self.duration = try container.decode(String.self, forKey: .duration)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(config, forKey: .config)
        try container.encode(duration, forKey: .duration)
    }
}

extension GetConfigResponse: Hashable {
    public static func == (lhs: GetConfigResponse, rhs: GetConfigResponse) -> Bool {
        lhs.config == rhs.config &&
            lhs.duration == rhs.duration
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(config)
        hasher.combine(duration)
    }
}
