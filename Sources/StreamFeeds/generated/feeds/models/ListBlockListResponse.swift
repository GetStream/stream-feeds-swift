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

    public init(blocklists: [BlockListResponse], duration: String) {
        self.blocklists = blocklists
        self.duration = duration
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case blocklists
        case duration
    }
}

extension ListBlockListResponse: Hashable {
    public static func == (lhs: ListBlockListResponse, rhs: ListBlockListResponse) -> Bool {
        lhs.blocklists == rhs.blocklists &&
            lhs.duration == rhs.duration
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(blocklists)
        hasher.combine(duration)
    }
}
