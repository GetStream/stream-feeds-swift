//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class AddReactionResponse: @unchecked Sendable, Codable, JSONEncodable {
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

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.activity = try container.decode(ActivityResponse.self, forKey: .activity)
        self.duration = try container.decode(String.self, forKey: .duration)
        self.reaction = try container.decode(FeedsReactionResponse.self, forKey: .reaction)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(activity, forKey: .activity)
        try container.encode(duration, forKey: .duration)
        try container.encode(reaction, forKey: .reaction)
    }
}

extension AddReactionResponse: Hashable {
    public static func == (lhs: AddReactionResponse, rhs: AddReactionResponse) -> Bool {
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
