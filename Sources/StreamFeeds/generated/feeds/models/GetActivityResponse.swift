//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class GetActivityResponse: Sendable, Decodable {
    public let activity: ActivityResponse

    public init(activity: ActivityResponse) {
        self.activity = activity
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.activity = try container.decode(ActivityResponse.self, forKey: .activity)
    }
}

extension GetActivityResponse: Hashable {
    public static func == (lhs: GetActivityResponse, rhs: GetActivityResponse) -> Bool {
        lhs.activity == rhs.activity
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(activity)
    }
}
