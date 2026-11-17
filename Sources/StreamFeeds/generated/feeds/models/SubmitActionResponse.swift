//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class SubmitActionResponse: Sendable, Decodable {
    public let item: ReviewQueueItemResponse?

    public init(item: ReviewQueueItemResponse? = nil) {
        self.item = item
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.item = try container.decodeIfPresent(ReviewQueueItemResponse.self, forKey: .item)
    }
}

extension SubmitActionResponse: Hashable {
    public static func == (lhs: SubmitActionResponse, rhs: SubmitActionResponse) -> Bool {
        lhs.item == rhs.item
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(item)
    }
}
