//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Basic response information
public final class CreateBlockListResponse: Sendable, Decodable {
    /// Block list contains restricted words
    public let blocklist: BlockListResponse?
    /// Duration of the request in milliseconds
    public let duration: String

    public init(blocklist: BlockListResponse? = nil, duration: String) {
        self.blocklist = blocklist
        self.duration = duration
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.blocklist = try container.decodeIfPresent(BlockListResponse.self, forKey: .blocklist)
        self.duration = try container.decode(String.self, forKey: .duration)
    }
}

extension CreateBlockListResponse: Hashable {
    public static func == (lhs: CreateBlockListResponse, rhs: CreateBlockListResponse) -> Bool {
        lhs.blocklist == rhs.blocklist &&
            lhs.duration == rhs.duration
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(blocklist)
        hasher.combine(duration)
    }
}
