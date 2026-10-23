//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UpdateActivityPartialResponse: Sendable, Codable, JSONEncodable {
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

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(activity, forKey: .activity)
        try container.encode(duration, forKey: .duration)
    }
}

extension UpdateActivityPartialResponse: Hashable {
    public static func == (lhs: UpdateActivityPartialResponse, rhs: UpdateActivityPartialResponse) -> Bool {
        lhs.activity == rhs.activity &&
            lhs.duration == rhs.duration
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(activity)
        hasher.combine(duration)
    }
}
