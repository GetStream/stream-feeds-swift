//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UpdateFeedRequest: Sendable, Encodable, JSONEncodable {
    /// Custom data for the feed
    public let custom: [String: RawJSON]?

    public init(custom: [String: RawJSON]? = nil) {
        self.custom = custom
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(custom, forKey: .custom)
    }
}

extension UpdateFeedRequest: Hashable {
    public static func == (lhs: UpdateFeedRequest, rhs: UpdateFeedRequest) -> Bool {
        lhs.custom == rhs.custom
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(custom)
    }
}
