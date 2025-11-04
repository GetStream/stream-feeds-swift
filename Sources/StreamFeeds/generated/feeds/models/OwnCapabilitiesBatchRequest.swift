//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class OwnCapabilitiesBatchRequest: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var feeds: [String]

    public init(feeds: [String]) {
        self.feeds = feeds
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case feeds
    }

    public static func == (lhs: OwnCapabilitiesBatchRequest, rhs: OwnCapabilitiesBatchRequest) -> Bool {
        lhs.feeds == rhs.feeds
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(feeds)
    }
}
