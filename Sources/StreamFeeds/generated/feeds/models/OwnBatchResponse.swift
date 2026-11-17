//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class OwnBatchResponse: Sendable, Decodable {
    /// Map of feed ID to own fields data
    public let data: [String: FeedOwnData]

    public init(data: [String: FeedOwnData]) {
        self.data = data
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.data = try container.decode([String: FeedOwnData].self, forKey: .data)
    }
}

extension OwnBatchResponse: Hashable {
    public static func == (lhs: OwnBatchResponse, rhs: OwnBatchResponse) -> Bool {
        lhs.data == rhs.data
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(data)
    }
}
