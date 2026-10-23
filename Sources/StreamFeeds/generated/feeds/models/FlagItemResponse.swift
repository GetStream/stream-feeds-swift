//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class FlagItemResponse: Sendable, Decodable {
    public let duration: String
    /// Unique identifier of the created moderation item
    public let itemId: String

    public init(duration: String, itemId: String) {
        self.duration = duration
        self.itemId = itemId
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.duration = try container.decode(String.self, forKey: .duration)
        self.itemId = try container.decode(String.self, forKey: .itemId)
    }
}

extension FlagItemResponse: Hashable {
    public static func == (lhs: FlagItemResponse, rhs: FlagItemResponse) -> Bool {
        lhs.duration == rhs.duration &&
            lhs.itemId == rhs.itemId
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(duration)
        hasher.combine(itemId)
    }
}
