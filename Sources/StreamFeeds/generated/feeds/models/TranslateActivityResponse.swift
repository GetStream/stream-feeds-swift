//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Basic response information
public final class TranslateActivityResponse: Sendable, Decodable {
    public let activity: ActivityResponse

    public init(activity: ActivityResponse) {
        self.activity = activity
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.activity = try container.decode(ActivityResponse.self, forKey: .activity)
    }
}

extension TranslateActivityResponse: Hashable {
    public static func == (lhs: TranslateActivityResponse, rhs: TranslateActivityResponse) -> Bool {
        lhs.activity == rhs.activity
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(activity)
    }
}
