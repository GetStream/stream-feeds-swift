//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class MuteRequest: @unchecked Sendable, Codable, JSONEncodable {
    /// User IDs to mute (if multiple users)
    public var targetIds: [String]
    /// Duration of mute in minutes
    public var timeout: Int?

    public init(targetIds: [String], timeout: Int? = nil) {
        self.targetIds = targetIds
        self.timeout = timeout
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case targetIds = "target_ids"
        case timeout
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
