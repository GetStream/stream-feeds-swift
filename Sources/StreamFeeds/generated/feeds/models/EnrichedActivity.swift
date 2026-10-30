//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class EnrichedActivity: Sendable, Decodable {
    public let actor: StreamData?
    public let foreignId: String?
    public let id: String?
    public let latestReactions: [String: [EnrichedReaction]]?
    public let object: StreamData?
    public let origin: StreamData?
    public let ownReactions: [String: [EnrichedReaction]]?
    public let reactionCounts: [String: Int]?
    public let score: Double?
    public let target: StreamData?
    public let to: [String]?
    public let verb: String?

    public init(actor: StreamData? = nil, foreignId: String? = nil, id: String? = nil, latestReactions: [String: [EnrichedReaction]]? = nil, object: StreamData? = nil, origin: StreamData? = nil, ownReactions: [String: [EnrichedReaction]]? = nil, reactionCounts: [String: Int]? = nil, score: Double? = nil, target: StreamData? = nil, to: [String]? = nil, verb: String? = nil) {
        self.actor = actor
        self.foreignId = foreignId
        self.id = id
        self.latestReactions = latestReactions
        self.object = object
        self.origin = origin
        self.ownReactions = ownReactions
        self.reactionCounts = reactionCounts
        self.score = score
        self.target = target
        self.to = to
        self.verb = verb
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.actor = try container.decodeIfPresent(StreamData.self, forKey: .actor)
        self.foreignId = try container.decodeIfPresent(String.self, forKey: .foreignId)
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.latestReactions = try container.decodeIfPresent([String: [EnrichedReaction]].self, forKey: .latestReactions)
        self.object = try container.decodeIfPresent(StreamData.self, forKey: .object)
        self.origin = try container.decodeIfPresent(StreamData.self, forKey: .origin)
        self.ownReactions = try container.decodeIfPresent([String: [EnrichedReaction]].self, forKey: .ownReactions)
        self.reactionCounts = try container.decodeIfPresent([String: Int].self, forKey: .reactionCounts)
        self.score = try container.decodeIfPresent(Double.self, forKey: .score)
        self.target = try container.decodeIfPresent(StreamData.self, forKey: .target)
        self.to = try container.decodeIfPresent([String].self, forKey: .to)
        self.verb = try container.decodeIfPresent(String.self, forKey: .verb)
    }
}

extension EnrichedActivity: Hashable {
    public static func == (lhs: EnrichedActivity, rhs: EnrichedActivity) -> Bool {
        lhs.actor == rhs.actor &&
            lhs.foreignId == rhs.foreignId &&
            lhs.id == rhs.id &&
            lhs.latestReactions == rhs.latestReactions &&
            lhs.object == rhs.object &&
            lhs.origin == rhs.origin &&
            lhs.ownReactions == rhs.ownReactions &&
            lhs.reactionCounts == rhs.reactionCounts &&
            lhs.score == rhs.score &&
            lhs.target == rhs.target &&
            lhs.to == rhs.to &&
            lhs.verb == rhs.verb
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(actor)
        hasher.combine(foreignId)
        hasher.combine(id)
        hasher.combine(latestReactions)
        hasher.combine(object)
        hasher.combine(origin)
        hasher.combine(ownReactions)
        hasher.combine(reactionCounts)
        hasher.combine(score)
        hasher.combine(target)
        hasher.combine(to)
        hasher.combine(verb)
    }
}
