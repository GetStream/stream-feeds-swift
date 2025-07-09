//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UpdateActivityResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var activity: ActivityResponse
    public var duration: String

    public init(activity: ActivityResponse, duration: String) {
        self.activity = activity
        self.duration = duration
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case activity
        case duration
    }

    public static func == (lhs: UpdateActivityResponse, rhs: UpdateActivityResponse) -> Bool {
        lhs.activity == rhs.activity &&
            lhs.duration == rhs.duration
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(activity)
        hasher.combine(duration)
    }
}
