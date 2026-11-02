//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class DeleteActivityReactionResponse: Sendable, Decodable {
    public let activity: ActivityResponse
    public let duration: String
    public let reaction: FeedsReactionResponse

    public init(activity: ActivityResponse, duration: String, reaction: FeedsReactionResponse) {
        self.activity = activity
        self.duration = duration
        self.reaction = reaction
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.activity = try container.decode(ActivityResponse.self, forKey: .activity)
        self.duration = try container.decode(String.self, forKey: .duration)
        self.reaction = try container.decode(FeedsReactionResponse.self, forKey: .reaction)
    }
}

extension DeleteActivityReactionResponse: Hashable {
    public static func == (lhs: DeleteActivityReactionResponse, rhs: DeleteActivityReactionResponse) -> Bool {
        lhs.activity == rhs.activity &&
            lhs.duration == rhs.duration &&
            lhs.reaction == rhs.reaction
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(activity)
        hasher.combine(duration)
        hasher.combine(reaction)
    }
}
