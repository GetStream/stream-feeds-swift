//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class GetActivityResponse: @unchecked Sendable, Codable, JSONEncodable {
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
}

extension GetActivityResponse: Hashable {
    public static func == (lhs: GetActivityResponse, rhs: GetActivityResponse) -> Bool {
        lhs.activity == rhs.activity &&
            lhs.duration == rhs.duration
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(activity)
        hasher.combine(duration)
    }
}
