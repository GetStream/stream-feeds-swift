//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class OwnBatchResponse: Sendable, Decodable {
    /// Map of feed ID to own fields data
    public let data: [String: FeedOwnData]
    public let duration: String

    public init(data: [String: FeedOwnData], duration: String) {
        self.data = data
        self.duration = duration
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.data = try container.decode([String: FeedOwnData].self, forKey: .data)
        self.duration = try container.decode(String.self, forKey: .duration)
    }
}

extension OwnBatchResponse: Hashable {
    public static func == (lhs: OwnBatchResponse, rhs: OwnBatchResponse) -> Bool {
        lhs.data == rhs.data &&
            lhs.duration == rhs.duration
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(data)
        hasher.combine(duration)
    }
}
