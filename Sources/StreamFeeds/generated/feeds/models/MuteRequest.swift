//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class MuteRequest: Sendable, Encodable, JSONEncodable {
    /// User IDs to mute (if multiple users)
    public let targetIds: [String]
    /// Duration of mute in minutes
    public let timeout: Int?

    public init(targetIds: [String], timeout: Int? = nil) {
        self.targetIds = targetIds
        self.timeout = timeout
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(targetIds, forKey: .targetIds)
        try container.encodeIfPresent(timeout, forKey: .timeout)
    }
}

extension MuteRequest: Hashable {
    public static func == (lhs: MuteRequest, rhs: MuteRequest) -> Bool {
        lhs.targetIds == rhs.targetIds &&
            lhs.timeout == rhs.timeout
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(targetIds)
        hasher.combine(timeout)
    }
}
