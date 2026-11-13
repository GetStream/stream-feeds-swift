//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class GetConfigResponse: Sendable, Decodable {
    public let config: ConfigResponse?

    public init(config: ConfigResponse? = nil) {
        self.config = config
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.config = try container.decodeIfPresent(ConfigResponse.self, forKey: .config)
    }
}

extension GetConfigResponse: Hashable {
    public static func == (lhs: GetConfigResponse, rhs: GetConfigResponse) -> Bool {
        lhs.config == rhs.config
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(config)
    }
}
