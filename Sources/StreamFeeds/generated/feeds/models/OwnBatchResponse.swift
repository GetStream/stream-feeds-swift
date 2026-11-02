//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class OwnBatchResponse: @unchecked Sendable, Codable, JSONEncodable {
    /// Map of feed ID to own fields data
    public var data: [String: FeedOwnData]
    public var duration: String

    public init(data: [String: FeedOwnData], duration: String) {
        self.data = data
        self.duration = duration
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case data
        case duration
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
