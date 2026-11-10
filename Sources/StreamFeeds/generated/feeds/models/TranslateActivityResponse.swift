//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Basic response information
public final class TranslateActivityResponse: Sendable, Decodable {
    public let activity: ActivityResponse
    /// Duration of the request in milliseconds
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

extension TranslateActivityResponse: Hashable {
    public static func == (lhs: TranslateActivityResponse, rhs: TranslateActivityResponse) -> Bool {
        lhs.activity == rhs.activity &&
            lhs.duration == rhs.duration
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(activity)
        hasher.combine(duration)
    }
}
