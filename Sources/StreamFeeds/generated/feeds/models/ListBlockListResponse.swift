//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Basic response information
public final class ListBlockListResponse: @unchecked Sendable, Codable, JSONEncodable {
    public var blocklists: [BlockListResponse]
    /// Duration of the request in milliseconds
    public var duration: String
    public var nextCursor: String?

    public init(blocklists: [BlockListResponse], duration: String, nextCursor: String? = nil) {
        self.blocklists = blocklists
        self.duration = duration
        self.nextCursor = nextCursor
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case blocklists
        case duration
        case nextCursor = "next_cursor"
    }
}

extension ListBlockListResponse: Hashable {
    public static func == (lhs: ListBlockListResponse, rhs: ListBlockListResponse) -> Bool {
        lhs.blocklists == rhs.blocklists &&
            lhs.duration == rhs.duration &&
            lhs.nextCursor == rhs.nextCursor
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(blocklists)
        hasher.combine(duration)
        hasher.combine(nextCursor)
    }
}
