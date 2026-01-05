//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class FlagResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var duration: String
    public var itemId: String

    public init(duration: String, itemId: String) {
        self.duration = duration
        self.itemId = itemId
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case duration
        case itemId = "item_id"
    }

    public static func == (lhs: FlagResponse, rhs: FlagResponse) -> Bool {
        lhs.duration == rhs.duration &&
            lhs.itemId == rhs.itemId
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(duration)
        hasher.combine(itemId)
    }
}
