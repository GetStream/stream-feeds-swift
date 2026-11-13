//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class AddReactionResponse: Sendable, Decodable {
    public let activity: ActivityResponse
    public let reaction: FeedsReactionResponse

    public init(activity: ActivityResponse, reaction: FeedsReactionResponse) {
        self.activity = activity
        self.reaction = reaction
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.activity = try container.decode(ActivityResponse.self, forKey: .activity)
        self.reaction = try container.decode(FeedsReactionResponse.self, forKey: .reaction)
    }
}

extension AddReactionResponse: Hashable {
    public static func == (lhs: AddReactionResponse, rhs: AddReactionResponse) -> Bool {
        lhs.activity == rhs.activity &&
            lhs.reaction == rhs.reaction
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(activity)
        hasher.combine(reaction)
    }
}
