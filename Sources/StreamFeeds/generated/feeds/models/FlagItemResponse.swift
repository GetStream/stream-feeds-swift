//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class FlagItemResponse: @unchecked Sendable, Codable, JSONEncodable {
    public var duration: String
    /// Unique identifier of the created moderation item
    public var itemId: String

    public init(duration: String, itemId: String) {
        self.duration = duration
        self.itemId = itemId
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case duration
        case itemId = "item_id"
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
