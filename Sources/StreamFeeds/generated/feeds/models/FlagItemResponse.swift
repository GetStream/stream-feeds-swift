//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class FlagItemResponse: Sendable, Decodable {
    /// Unique identifier of the created moderation item
    public let itemId: String

    public init(itemId: String) {
        self.itemId = itemId
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.itemId = try container.decode(String.self, forKey: .itemId)
    }
}

extension FlagItemResponse: Hashable {
    public static func == (lhs: FlagItemResponse, rhs: FlagItemResponse) -> Bool {
        lhs.itemId == rhs.itemId
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(itemId)
    }
}
