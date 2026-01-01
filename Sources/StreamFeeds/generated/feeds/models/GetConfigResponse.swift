//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class GetConfigResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var config: ConfigResponse?
    public var duration: String

    public init(config: ConfigResponse? = nil, duration: String) {
        self.config = config
        self.duration = duration
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case config
        case duration
    }

    public static func == (lhs: GetConfigResponse, rhs: GetConfigResponse) -> Bool {
        lhs.config == rhs.config &&
            lhs.duration == rhs.duration
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(config)
        hasher.combine(duration)
    }
}
