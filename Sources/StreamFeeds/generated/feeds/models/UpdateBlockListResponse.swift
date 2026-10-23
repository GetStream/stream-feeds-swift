//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Basic response information
public final class UpdateBlockListResponse: @unchecked Sendable, Codable, JSONEncodable {
    /// Block list contains restricted words
    public var blocklist: BlockListResponse?
    /// Duration of the request in milliseconds
    public var duration: String

    public init(blocklist: BlockListResponse? = nil, duration: String) {
        self.blocklist = blocklist
        self.duration = duration
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case blocklist
        case duration
    }
}

extension UpdateBlockListResponse: Hashable {
    public static func == (lhs: UpdateBlockListResponse, rhs: UpdateBlockListResponse) -> Bool {
        lhs.blocklist == rhs.blocklist &&
            lhs.duration == rhs.duration
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(blocklist)
        hasher.combine(duration)
    }
}
