//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class SubmitActionResponse: @unchecked Sendable, Codable, JSONEncodable {
    public var duration: String
    public var item: ReviewQueueItemResponse?

    public init(duration: String, item: ReviewQueueItemResponse? = nil) {
        self.duration = duration
        self.item = item
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case duration
        case item
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
