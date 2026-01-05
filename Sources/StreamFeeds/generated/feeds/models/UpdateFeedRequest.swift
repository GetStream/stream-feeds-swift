//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UpdateFeedRequest: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var custom: [String: RawJSON]?

    public init(custom: [String: RawJSON]? = nil) {
        self.custom = custom
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case custom
    }

    public static func == (lhs: UpdateFeedRequest, rhs: UpdateFeedRequest) -> Bool {
        lhs.custom == rhs.custom
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(custom)
    }
}
