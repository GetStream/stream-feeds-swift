//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class DeleteFeedResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var duration: String

    public init(duration: String) {
        self.duration = duration
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case duration
    }

    public static func == (lhs: DeleteFeedResponse, rhs: DeleteFeedResponse) -> Bool {
        lhs.duration == rhs.duration
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(duration)
    }
}
