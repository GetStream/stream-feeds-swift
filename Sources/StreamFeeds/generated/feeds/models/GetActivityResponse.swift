//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class GetActivityResponse: Sendable, Decodable {
    public let activity: ActivityResponse
    public let duration: String

    public init(activity: ActivityResponse, duration: String) {
        self.activity = activity
        self.duration = duration
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.activity = try container.decode(ActivityResponse.self, forKey: .activity)
        self.duration = try container.decode(String.self, forKey: .duration)
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
