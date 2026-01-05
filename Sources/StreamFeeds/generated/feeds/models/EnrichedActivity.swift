//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class EnrichedActivity: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var actor: StreamData?
    public var foreignId: String?
    public var id: String?
    public var latestReactions: [String: [EnrichedReaction]]?
    public var object: StreamData?
    public var origin: StreamData?
    public var ownReactions: [String: [EnrichedReaction]]?
    public var reactionCounts: [String: Int]?
    public var score: Float?
    public var target: StreamData?
    public var to: [String]?
    public var verb: String?

    public init(actor: StreamData? = nil, foreignId: String? = nil, id: String? = nil, latestReactions: [String: [EnrichedReaction]]? = nil, object: StreamData? = nil, origin: StreamData? = nil, ownReactions: [String: [EnrichedReaction]]? = nil, reactionCounts: [String: Int]? = nil, score: Float? = nil, target: StreamData? = nil, to: [String]? = nil, verb: String? = nil) {
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

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case actor
        case foreignId = "foreign_id"
        case id
        case latestReactions = "latest_reactions"
        case object
        case origin
        case ownReactions = "own_reactions"
        case reactionCounts = "reaction_counts"
        case score
        case target
        case to
        case verb
    }

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
