//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class CreateBlockListResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var blocklist: BlockListResponse?
    public var duration: String

    public init(blocklist: BlockListResponse? = nil, duration: String) {
        self.blocklist = blocklist
        self.duration = duration
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case blocklist
        case duration
    }

    public static func == (lhs: CreateBlockListResponse, rhs: CreateBlockListResponse) -> Bool {
        lhs.blocklist == rhs.blocklist &&
            lhs.duration == rhs.duration
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(blocklist)
        hasher.combine(duration)
    }
}
