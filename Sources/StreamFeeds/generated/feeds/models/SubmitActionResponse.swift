//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class SubmitActionResponse: Sendable, Codable, JSONEncodable {
    public let duration: String
    public let item: ReviewQueueItemResponse?

    public init(duration: String, item: ReviewQueueItemResponse? = nil) {
        self.duration = duration
        self.item = item
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.duration = try container.decode(String.self, forKey: .duration)
        self.item = try container.decodeIfPresent(ReviewQueueItemResponse.self, forKey: .item)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(duration, forKey: .duration)
        try container.encodeIfPresent(item, forKey: .item)
    }
}

extension SubmitActionResponse: Hashable {
    public static func == (lhs: SubmitActionResponse, rhs: SubmitActionResponse) -> Bool {
        lhs.duration == rhs.duration &&
            lhs.item == rhs.item
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(duration)
        hasher.combine(item)
    }
}
