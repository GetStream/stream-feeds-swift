//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class DeleteActivityReactionResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var activity: ActivityResponse
    public var duration: String
    public var reaction: FeedsReactionResponse

    public init(activity: ActivityResponse, duration: String, reaction: FeedsReactionResponse) {
        self.activity = activity
        self.duration = duration
        self.reaction = reaction
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case activity
        case duration
        case reaction
    }

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
